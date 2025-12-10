//
//  jelingua_macosApp.swift
//  jelingua-macos
//
//  Created by Roman Zheltov on 08.12.2025.
//

import SwiftUI
import AppKit

@main
struct jelingua_macosApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

