//
//  TranslationUseCase.swift
//  JelinguaMacOS
//
//  Created by Roman Zheltov on 15.12.2025.
//

final class TranslationUseCase {
    private let api: TranslationApiClient

    init(api: TranslationApiClient = TranslationApiClient()) {
        self.api = api
    }

    func translateEnToRu(_ text: String) async throws -> TranslationResponse {
        try await api.translate(text: text, sourceLang: "en", targetLang: "ru")
    }
}
