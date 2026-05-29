//
//  MenuBarTimerApp.swift
//  MenuBarTimer
//
//  Created by Arthur Norat on 28/05/26.
//

import SwiftUI
import AppKit
import Combine

@main
struct MenuBarTimerApp: App {
    @NSApplicationDelegateAdaptor(StatusBarController.self) var appDelegate

    var body: some Scene {
        Settings { EmptyView() }
    }
}

class StatusBarController: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    let timerController = TimerController()
    private var cancellables = Set<AnyCancellable>()

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        guard let button = statusItem.button else { return }
        button.title = timerController.idleDisplayString
        button.action = #selector(handleClick(_:))
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        button.target = self

        timerController.$timeRemaining
            .sink { [weak self] _ in self?.updateButton() }
            .store(in: &cancellables)

        timerController.$state
            .sink { [weak self] _ in self?.updateButton() }
            .store(in: &cancellables)
    }

    private func updateButton() {
        guard let button = statusItem.button else { return }
        button.title = timerController.state == .idle
            ? timerController.idleDisplayString
            : timerController.displayString
    }

    @objc private func handleClick(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        if event.type == .rightMouseUp {
            print("right click — panel will open here")
        } else {
            switch timerController.state {
            case .idle:
                timerController.start()
            case .work, .rest:
                timerController.isPaused ? timerController.resume() : timerController.pause()
            }
        }
    }
}
