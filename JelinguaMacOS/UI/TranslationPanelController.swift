//
//  TranslationPanelController.swift
//  JelinguaMacOS
//
//  Created by Roman Zheltov on 15.12.2025.
//

import AppKit
import SwiftUI

@MainActor
final class TranslationPanelController {
    static let shared = TranslationPanelController()

    private var panel: NSPanel?

    func show(response: TranslationResponse, onSave: @escaping () -> Void) {
        let view = TranslationResultView(
            response: response,
            onCopy: {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(response.translation, forType: .string)
            },
            onSave: onSave,
            onClose: { self.close() }
        )

        showAnyView(AnyView(view))
    }

    func showError(_ message: String) {
        let view = VStack(alignment: .leading, spacing: 12) {
            Text("Translation error").font(.headline)
            Text(message).textSelection(.enabled)
            HStack {
                Spacer()
                Button("Close") { self.close() }
                    .keyboardShortcut(.cancelAction)
            }
        }
        .padding(14)
        .frame(width: 420)

        showAnyView(AnyView(view))
    }

    func close() {
        panel?.orderOut(nil)
    }

    // MARK: - Private

    private func showAnyView(_ view: AnyView) {
        let hosting = NSHostingController(rootView: view)

        let panel = self.panel ?? makePanel()
        panel.contentView = hosting.view
        self.panel = panel

        position(panel: panel)
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func makePanel() -> NSPanel {
        let p = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 420, height: 260),
            styleMask: [.titled, .closable, .utilityWindow, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        p.isFloatingPanel = true
        p.level = .floating
        p.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        p.titleVisibility = .hidden
        p.titlebarAppearsTransparent = true
        p.isReleasedWhenClosed = false
        return p
    }

    private func position(panel: NSPanel) {
        let mouse = NSEvent.mouseLocation

        let screen = NSScreen.screens.first(where: { $0.frame.contains(mouse) }) ?? NSScreen.main
        guard let screen else {
            panel.center()
            return
        }

        let screenFrame = screen.visibleFrame
        let size = panel.frame.size

        var x = mouse.x + 12
        var y = mouse.y - size.height - 12

        x = min(max(x, screenFrame.minX), screenFrame.maxX - size.width)
        y = min(max(y, screenFrame.minY), screenFrame.maxY - size.height)

        panel.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
