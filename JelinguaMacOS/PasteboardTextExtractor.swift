//
//  PasteboardTextExtractor.swift
//  JelinguaMacOS
//
//  Created by Roman Zheltov on 15.12.2025.
//

import AppKit

struct PasteboardTextExtractor {

    enum ExtractError: LocalizedError {
        case empty
        var errorDescription: String? { "No text found on pasteboard" }
    }

    func extract(from pasteboard: NSPasteboard) throws -> String {
        let text =
            pasteboard.string(forType: .string)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !text.isEmpty else { throw ExtractError.empty }
        return text
    }
}
