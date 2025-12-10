//
//  ActionRequestHandler.swift
//  JelinguaTranslateExtension
//
//  Created by Roman Zheltov on 09.12.2025.
//

import Foundation
import UniformTypeIdentifiers

/// Handles incoming Service requests (selected text) and sends it to the translation backend.
class ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    
    func beginRequest(with context: NSExtensionContext) {
        // We expect at least one input item
        guard let item = context.inputItems.first as? NSExtensionItem,
              let attachments = item.attachments,
              !attachments.isEmpty else {
            NSLog("Jelingua: No input items or attachments")
            context.cancelRequest(withError: NSError(
                domain: "JelinguaErrorDomain",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "No input text"]
            ))
            return
        }
        
        // Look for a provider that can give us plain text
        let textType = UTType.plainText.identifier
        
        guard let provider = attachments.first(where: { $0.hasItemConformingToTypeIdentifier(textType) }) else {
            NSLog("Jelingua: No provider with plain text")
            context.cancelRequest(withError: NSError(
                domain: "JelinguaErrorDomain",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "No text provider"]
            ))
            return
        }
        
        // Load the selected text
        provider.loadItem(forTypeIdentifier: textType, options: nil) { (item, error) in
            if let error = error {
                NSLog("Jelingua: Error loading item: \(error)")
                context.cancelRequest(withError: error as NSError)
                return
            }
            
            guard let item = item else {
                NSLog("Jelingua: Loaded item is nil")
                context.cancelRequest(withError: NSError(
                    domain: "JelinguaErrorDomain",
                    code: 3,
                    userInfo: [NSLocalizedDescriptionKey: "Empty item"]
                ))
                return
            }
            
            // Convert loaded item to String
            let text: String?
            
            if let s = item as? String {
                text = s
            } else if let url = item as? URL {
                // Sometimes text is passed as a file URL
                text = try? String(contentsOf: url)
            } else {
                text = nil
            }
            
            guard let selectedText = text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !selectedText.isEmpty else {
                NSLog("Jelingua: No valid text extracted")
                context.cancelRequest(withError: NSError(
                    domain: "JelinguaErrorDomain",
                    code: 4,
                    userInfo: [NSLocalizedDescriptionKey: "No valid text"]
                ))
                return
            }
            
            NSLog("Jelingua: Selected text = \(selectedText)")
            
            // Call the backend using our API client
            Task {
                let api = TranslationApiClient()
                
                do {
                    let response = try await api.translate(text: selectedText)
                    NSLog("Jelingua: Translation success. Original=\(response.original), Translation=\(response.translation)")
                    
                    // For now, we just log and complete without modifying text
                    context.completeRequest(returningItems: [], completionHandler: nil)
                    
                } catch {
                    NSLog("Jelingua: Translation error: \(error)")
                    context.cancelRequest(withError: error as NSError)
                }
            }
        }
    }
}
