//
//  JelinguaServicesProvider.swift
//  jelingua-macos
//
//  Created by Roman Zheltov on 10.12.2025.
//

import AppKit

/// Provides macOS Services for Jelingua (Translate with Jelingua).
final class JelinguaServicesProvider: NSObject {
    
    /// Service method called from the Services menu.
    ///
    /// Signature is important: it must match NSMessage in NSServices ("translateSelection:")
    @objc func translateSelection(_ pboard: NSPasteboard,
                                  userData: String,
                                  error: AutoreleasingUnsafeMutablePointer<NSString?>) {
        
        // Try to read a string from the pasteboard
        guard let text = pboard.string(forType: .string)?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else {
            return
        }
        
        // Call backend asynchronously
        Task {
            let api = TranslationApiClient()
            
            do {
                let response = try await api.translate(text: text)
                
                await MainActor.run {
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


