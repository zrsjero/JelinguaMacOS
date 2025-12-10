//
//  AppDelegate.swift
//  jelingua-macos
//
//  Created by Roman Zheltov on 10.12.2025.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let servicesProvider = JelinguaServicesProvider()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Register our services provider so macOS can call it from the Services menu
        NSApp.servicesProvider = servicesProvider
    }
}
