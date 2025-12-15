//
//  JelinguaServicesProvider.swift
//  jelingua-macos
//
//  Created by Roman Zheltov on 10.12.2025.
//

import AppKit

final class JelinguaServicesProvider: NSObject {
    private let extractor = PasteboardTextExtractor()
    private let useCase = TranslationUseCase()

    @objc func translate(
        _ pasteboard: NSPasteboard,
        userData: String?,
        error outError: AutoreleasingUnsafeMutablePointer<NSString>
    ) {
        NSLog("JelinguaService: translate() called")

        let text: String
        do {
            text = try extractor.extract(from: pasteboard)
        } catch {
            outError.pointee = (error.localizedDescription as NSString)
            return
        }

        Task {
            do {
                let response = try await useCase.translateEnToRu(text)

                await MainActor.run {
                    TranslationPanelController.shared.show(response: response) {
                        NSLog("TODO: Save to backend: \(response.original) -> \(response.translation)")
                    }
                }
            } catch {
                await MainActor.run {
                    TranslationPanelController.shared.showError(error.localizedDescription)
                }
            }
        }
    }
}
