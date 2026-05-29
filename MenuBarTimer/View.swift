import SwiftUI
import KeyboardShortcuts
import LaunchAtLogin

extension KeyboardShortcuts.Name {
    static let startStop = Self("startStop")
}

struct TimerPanelView: View {
    @EnvironmentObject var timer: TimerController

    @AppStorage("workIntervalLength") private var workIntervalLength: Int = 25
    @AppStorage("shortRestIntervalLength") private var shortRestIntervalLength: Int = 5
    @AppStorage("longRestIntervalLength") private var longRestIntervalLength: Int = 15
    @AppStorage("workIntervalsInSet") private var workIntervalsInSet: Int = 4
    @AppStorage("stopAfterBreak") private var stopAfterBreak: Bool = false
    @AppStorage("showTimerInMenuBar") private var showTimerInMenuBar: Bool = true
    @AppStorage("dingVolume") private var dingVolume: Double = 0.5

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(stateLabel)
                    .font(.headline)
                Spacer()
                Text(timer.state == .idle ? timer.idleDisplayString : timer.displayString)
                    .font(.system(.title2, design: .monospaced).weight(.semibold))
            }
            .padding()

            Divider()

            VStack(spacing: 6) {
                row("Work") {
                    Stepper("\(workIntervalLength) min", value: $workIntervalLength, in: 1...60)
                }
                row("Short break") {
                    Stepper("\(shortRestIntervalLength) min", value: $shortRestIntervalLength, in: 1...30)
                }
                row("Long break") {
                    Stepper("\(longRestIntervalLength) min", value: $longRestIntervalLength, in: 1...60)
                }
                row("Intervals per set") {
                    Stepper("\(workIntervalsInSet)", value: $workIntervalsInSet, in: 1...10)
                }
            }
            .padding()

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Toggle("Stop after break", isOn: $stopAfterBreak)
                Toggle("Show timer in menu bar", isOn: $showTimerInMenuBar)
                LaunchAtLogin.Toggle("Launch at login")
            }
            .padding()
            .toggleStyle(.switch)

            VStack(spacing: 8) {
                row("Volume") {
                    Slider(value: $dingVolume, in: 0...1)
                        .frame(maxWidth: 120)
                }
                row("Shortcut") {
                    KeyboardShortcuts.Recorder("", name: .startStop)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 8)

            Divider()

            HStack(spacing: 8) {
                Spacer()
                if timer.state != .idle {
                    Button("Stop") { timer.stop() }
                        .buttonStyle(.bordered)
                }
                Button(mainButtonLabel, action: handleMainButton)
                    .buttonStyle(.borderedProminent)
                Spacer()
            }
            .padding()
        }
        .frame(width: 280)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.25), radius: 10, y: 5)
        .padding(8)
    }

    private func row<C: View>(_ label: String, @ViewBuilder content: () -> C) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary)
            Spacer()
            content()
        }
    }

    private var stateLabel: String {
        switch timer.state {
        case .idle: "Ready"
        case .work: timer.isPaused ? "Paused" : "Working"
        case .rest: "Break"
        }
    }

    private var mainButtonLabel: String {
        switch timer.state {
        case .idle: "Start"
        case .work, .rest: timer.isPaused ? "Resume" : "Pause"
        }
    }

    private func handleMainButton() {
        switch timer.state {
        case .idle: timer.start()
        case .work, .rest: timer.isPaused ? timer.resume() : timer.pause()
        }
    }
}
