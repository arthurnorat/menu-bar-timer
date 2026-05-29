//
//  MenuBarTimerApp.swift
//  MenuBarTimer
//
//  Created by Arthur Norat on 28/05/26.
//

import SwiftUI
import AppKit

@main
struct MenuBarTimerApp: App {
    @NSApplicationDelegateAdaptor(StatusBarController.self) var appDelegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}

class StatusBarController: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        guard let button = statusItem.button else { return }
        button.title = "25:00"
        button.action = #selector(handleClick(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        button.target = self
    }

    @objc private func handleClick(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        if event.type == .rightMouseUp {
            print("right click — panel will open here")
        } else {
            print("left click — timer will start/pause here")
        }
    }
}
