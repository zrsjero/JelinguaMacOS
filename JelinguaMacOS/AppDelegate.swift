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
        NSLog("JelinguaService: applicationDidFinishLaunching")
        
        NSApplication.shared.servicesProvider = servicesProvider
        
        // Просим систему перечитать NSServices
        NSUpdateDynamicServices()
    }
}
