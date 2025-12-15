//
//  TranslationModels.swift
//  jelingua-macos
//
//  Created by Roman Zheltov on 09.12.2025.
//


import Foundation

/// Request body for the translation API.
struct TranslationRequest: Codable {
    let text: String
    let sourceLang: String
    let targetLang: String
}

/// Response body from the translation API.
struct TranslationResponse: Codable {
    let original: String
    let translation: String
    let sourceLang: String
    let targetLang: String
}

