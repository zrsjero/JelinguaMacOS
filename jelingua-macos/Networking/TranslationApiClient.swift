//
//  TranslationApiClient.swift
//  jelingua-macos
//
//  Created by Roman Zheltov on 09.12.2025.
//

import Foundation

/// Simple API client for the translation backend.
final class TranslationApiClient {
    
    // Configuration for the API endpoints.
    struct Config {
        /// Base URL of your backend. Change this if needed.
        static var baseURL: URL = URL(string: "http://127.0.0.1:8080")!
        
        /// Path for the translation endpoint.
        static var translatePath: String = "/api/v1/translate"
    }
    
    /// A simple error type for API-related issues.
    enum ApiError: Error {
        case invalidURL
        case requestFailed(statusCode: Int)
        case noData
        case decodingFailed
    }
    
    /// The underlying URLSession used for network requests.
    private let session: URLSession
    
    /// Initialize the API client. Allows custom URLSession for testing.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Sends a translation request to the backend.
    ///
    /// - Parameters:
    ///   - text: The text to translate.
    ///   - sourceLang: Source language (e.g. "auto").
    ///   - targetLang: Target language (e.g. "ru").
    /// - Returns: `TranslationResponse` from the backend.
    /// - Throws: `ApiError` or any underlying `Error`.
    func translate(
        text: String,
        sourceLang: String = "en",
        targetLang: String = "ru"
    ) async throws -> TranslationResponse {
        
        // Build full URL: baseURL + translatePath
        let fullURL = Config.baseURL.appendingPathComponent(Config.translatePath)
        
        var request = URLRequest(url: fullURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let body = TranslationRequest(
            text: text,
            sourceLang: sourceLang,
            targetLang: targetLang
        )
        
        // Encode body as JSON
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)
        
        // Perform the request using async/await
        let (data, response) = try await session.data(for: request)
        
        // Check HTTP status code
        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw ApiError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        // Ensure we have data
        guard !data.isEmpty else {
            throw ApiError.noData
        }
        
        // Decode JSON response
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(TranslationResponse.self, from: data)
            return decoded
        } catch {
            throw ApiError.decodingFailed
        }
    }
}
