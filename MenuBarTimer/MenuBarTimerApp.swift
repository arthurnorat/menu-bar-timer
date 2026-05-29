//
//  MenuBarTimerApp.swift
//  MenuBarTimer
//
//  Created by Arthur Norat on 28/05/26.
//

import SwiftUI
import AppKit
import Combine
import KeyboardShortcuts

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
    private var panel: NSPanel?
    private var eventMonitor: Any?
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

        buildPanel()

        timerController.$timeRemaining
            .sink { [weak self] _ in self?.updateButton() }
            .store(in: &cancellables)

        timerController.$state
            .sink { [weak self] _ in self?.updateButton() }
            .store(in: &cancellables)

        NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.updateButton() }
            .store(in: &cancellables)

        KeyboardShortcuts.onKeyUp(for: .startStop) { [weak self] in
            self?.handleLeftClick()
        }
    }

    private func buildPanel() {
        let rootView = TimerPanelView().environmentObject(timerController)
        let hosting = NSHostingView(rootView: rootView)

        let p = NSPanel(
            contentRect: .zero,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        p.isOpaque = false
        p.backgroundColor = .clear
        p.level = .popUpMenu
        p.isMovableByWindowBackground = true
        p.contentView = hosting
        p.setContentSize(hosting.fittingSize)
        panel = p
    }

    private func updateButton() {
        guard let button = statusItem.button else { return }
        switch timerController.state {
        case .idle:
            button.title = timerController.showTimerInMenuBar ? timerController.idleDisplayString : "⏱"
        case .work, .rest:
            button.title = timerController.displayString
        }
    }

    @objc private func handleClick(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }
        if event.type == .rightMouseUp {
            togglePanel()
        } else {
            handleLeftClick()
        }
    }

    private func handleLeftClick() {
        switch timerController.state {
        case .idle:
            timerController.start()
        case .work, .rest:
            timerController.isPaused ? timerController.resume() : timerController.pause()
        }
    }

    private func togglePanel() {
        guard let panel else { return }
        panel.isVisible ? hidePanel() : showPanel()
    }

    private func showPanel() {
        guard let panel, let button = statusItem.button, let buttonWindow = button.window else { return }

        let buttonRect = button.convert(button.bounds, to: nil)
        let screenRect = buttonWindow.convertToScreen(buttonRect)

        panel.setFrameOrigin(NSPoint(
            x: screenRect.midX - panel.frame.width / 2,
            y: screenRect.minY - panel.frame.height
        ))
        panel.makeKeyAndOrderFront(nil)

        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            self?.hidePanel()
        }
    }

    private func hidePanel() {
        panel?.orderOut(nil)
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
}
