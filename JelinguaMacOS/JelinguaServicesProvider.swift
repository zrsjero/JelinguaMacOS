//
//  JelinguaServicesProvider.swift
//  jelingua-macos
//
//  Created by Roman Zheltov on 10.12.2025.
//

import AppKit

final class JelinguaServicesProvider: NSObject {
    
    /// Сигнатура 1-в-1 как в живом примере:
    /// @objc func <NSMessage>(
    ///   _ pasteboard: NSPasteboard,
    ///   userData: String?,
    ///   error: AutoreleasingUnsafeMutablePointer<NSString>
    /// )
    @objc func translate(
        _ pasteboard: NSPasteboard,
        userData: String?,
        error: AutoreleasingUnsafeMutablePointer<NSString>
    ) {
        NSLog("JelinguaService: translate() called")
        
        guard let text = pasteboard.string(forType: .string)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            NSLog("JelinguaService: no valid text on pasteboard")
            error.pointee = "No text found on pasteboard"
            return
        }
        
        NSLog("JelinguaService: got text = \(text)")
        
        Task {
            let api = TranslationApiClient()
            
            do {
                let response = try await api.translate(text: text)
                
                await MainActor.run {
                    NSLog("JelinguaService: translation OK = \(response.translation)")
                    
                    let alert = NSAlert()
                    alert.messageText = "Translation"
                    alert.informativeText = """
                    Original: \(response.original)
                    Translation: \(response.translation)
                    Source: \(response.sourceLang)
                    Target: \(response.targetLang)
                    """
                    alert.alertStyle = .informational
                    alert.runModal()
                }
            } catch {
                await MainActor.run {
                    NSLog("JelinguaService: translation error = \(error)")
                    
                    let alert = NSAlert()
                    alert.messageText = "Translation error"
                    alert.informativeText = error.localizedDescription
                    alert.alertStyle = .warning
                    alert.runModal()
                }
            }
        }
    }
}
