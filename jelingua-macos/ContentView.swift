//
//  ContentView.swift
//  jelingua-macos
//
//  Created by Roman Zheltov on 08.12.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var statusText: String = "Press the button to ping backend"
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Jelingua Backend Test")
                .font(.title)
            
            Button("Ping Backend") {
                pingBackend()
            }
            .buttonStyle(.borderedProminent)
            
            Text(statusText)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 200)
    }
    
    private func pingBackend() {
        statusText = "Pinging backend..."
        
        Task {
            let api = TranslationApiClient()
            do {
                let response = try await api.translate(text: "Hello")
                print("Translation response:", response)
                
                // Обновляем текст на экране
                await MainActor.run {
                    statusText = """
                    Backend OK

                    Original: Hello
                    Translated: \(response.translation)
                    Detected source: \(response.sourceLang)
                    """
                }
            } catch {
                print("Translation error:", error)
                
                await MainActor.run {
                    statusText = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
