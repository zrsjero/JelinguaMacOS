//
//  TranslationResultView.swift
//  JelinguaMacOS
//
//  Created by Roman Zheltov on 15.12.2025.
//

import SwiftUI

struct TranslationResultView: View {
    let response: TranslationResponse
    let onCopy: () -> Void
    let onSave: () -> Void
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Translation").font(.headline)

            GroupBox("Original") {
                Text(response.original)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            GroupBox("Translation") {
                Text(response.translation)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            HStack {
                Button("Copy") { onCopy() }
                Button("Save") { onSave() }   // <- будущая интеграция с backend
                Spacer()
                Button("Close") { onClose() }
                    .keyboardShortcut(.cancelAction)
            }
        }
        .padding(14)
        .frame(width: 420)
    }
}
