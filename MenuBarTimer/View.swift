import SwiftUI
import LaunchAtLogin

struct TimerPanelView: View {
    @EnvironmentObject var timer: TimerController

    @AppStorage("workIntervalLength") private var workIntervalLength: Int = 50
    @AppStorage("shortRestIntervalLength") private var shortRestIntervalLength: Int = 5
    @AppStorage("longRestIntervalLength") private var longRestIntervalLength: Int = 15
    @AppStorage("workIntervalsInSet") private var workIntervalsInSet: Int = 4
    @AppStorage("stopAfterBreak") private var stopAfterBreak: Bool = false
    @AppStorage("showTimerInMenuBar") private var showTimerInMenuBar: Bool = true
    @AppStorage("dingVolume") private var dingVolume: Double = 0.5

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .stroke(accentColor.opacity(0.15), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progress)
                VStack(spacing: 4) {
                    Text(timer.state == .idle ? timer.idleDisplayString : timer.displayString)
                        .font(.system(size: 52, weight: .semibold, design: .monospaced))
                    Text(stateLabel)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(24)

            HStack(spacing: 8) {
                if timer.state != .idle {
                    Button("Stop") { timer.stop() }
                        .buttonStyle(.bordered)
                }
                Button(mainButtonLabel, action: handleMainButton)
                    .buttonStyle(.borderedProminent)
                    .tint(accentColor)
            }
            .padding(.bottom, 16)

            Divider()

            VStack(spacing: 4) {
                row("Work") {
                    Stepper("\(workIntervalLength) min", value: $workIntervalLength, in: 1...120)
                }
                row("Short break") {
                    Stepper("\(shortRestIntervalLength) min", value: $shortRestIntervalLength, in: 1...30)
                }
                row("Long break") {
                    Stepper("\(longRestIntervalLength) min", value: $longRestIntervalLength, in: 1...60)
                }
                row("Intervals/set") {
                    Stepper("\(workIntervalsInSet)", value: $workIntervalsInSet, in: 1...10)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Toggle("Stop after break", isOn: $stopAfterBreak)
                Toggle("Show timer in menu bar", isOn: $showTimerInMenuBar)
                LaunchAtLogin.Toggle("Launch at login")
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .toggleStyle(.switch)

            VStack(spacing: 6) {
                row("Volume") {
                    Slider(value: $dingVolume, in: 0...1)
                        .frame(maxWidth: 120)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .frame(width: 280)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .clipShape(RoundedRectangle(cornerRadius: 12))
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

    private var accentColor: Color {
        switch timer.state {
        case .idle: .gray
        case .work: .orange
        case .rest: .green
        }
    }

    private var progress: Double {
        guard timer.totalDuration > 0 else { return 1.0 }
        return Double(timer.timeRemaining) / Double(timer.totalDuration)
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
