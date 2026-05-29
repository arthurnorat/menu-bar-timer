import SwiftUI
import Combine

enum TimerState {
    case idle, work, rest
}

class TimerController: ObservableObject {
    @Published var state: TimerState = .idle
    @Published var timeRemaining: Int = 0
    @Published var isPaused: Bool = false

    @AppStorage("workIntervalLength") var workIntervalLength: Int = 25
    @AppStorage("shortRestIntervalLength") var shortRestIntervalLength: Int = 5
    @AppStorage("longRestIntervalLength") var longRestIntervalLength: Int = 15
    @AppStorage("workIntervalsInSet") var workIntervalsInSet: Int = 4
    @AppStorage("stopAfterBreak") var stopAfterBreak: Bool = false
    @AppStorage("showTimerInMenuBar") var showTimerInMenuBar: Bool = true
    @AppStorage("dingVolume") var dingVolume: Double = 0.5

    private var dispatchTimer: DispatchSourceTimer?
    private(set) var completedWorkIntervals: Int = 0
    private let soundPlayer = SoundPlayer()
    private let notificationManager = NotificationManager()

    init() {
        timeRemaining = workIntervalLength * 60
        notificationManager.requestAuthorization()
    }

    var displayString: String {
        String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
    }

    var idleDisplayString: String {
        String(format: "%02d:00", workIntervalLength)
    }

    func start() {
        completedWorkIntervals = 0
        transition(to: .work)
    }

    func pause() {
        guard !isPaused, state != .idle else { return }
        isPaused = true
        dispatchTimer?.suspend()
    }

    func resume() {
        guard isPaused else { return }
        isPaused = false
        dispatchTimer?.resume()
    }

    func stop() {
        if isPaused {
            dispatchTimer?.resume()
            isPaused = false
        }
        dispatchTimer?.cancel()
        dispatchTimer = nil
        completedWorkIntervals = 0
        timeRemaining = workIntervalLength * 60
        state = .idle
    }

    func transition(to newState: TimerState) {
        let previousState = state

        if isPaused {
            dispatchTimer?.resume()
            isPaused = false
        }
        dispatchTimer?.cancel()
        dispatchTimer = nil

        state = newState

        switch newState {
        case .idle:
            timeRemaining = workIntervalLength * 60
        case .work:
            timeRemaining = workIntervalLength * 60
            if previousState != .idle {
                soundPlayer.play()
                notificationManager.notify(title: "Back to work", body: "Focus time started.")
            }
            startCountdown()
        case .rest:
            let isLongRest = completedWorkIntervals % workIntervalsInSet == 0
            timeRemaining = (isLongRest ? longRestIntervalLength : shortRestIntervalLength) * 60
            soundPlayer.play()
            notificationManager.notify(
                title: isLongRest ? "Long break" : "Short break",
                body: isLongRest ? "You earned a longer rest." : "Take a quick break."
            )
            startCountdown()
        }
    }

    private func startCountdown() {
        let t = DispatchSource.makeTimerSource(queue: .main)
        t.schedule(deadline: .now() + 1, repeating: 1.0)
        t.setEventHandler { [weak self] in
            guard let self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.onExpire()
            }
        }
        t.resume()
        dispatchTimer = t
    }

    private func onExpire() {
        switch state {
        case .idle:
            break
        case .work:
            completedWorkIntervals += 1
            transition(to: .rest)
        case .rest:
            if stopAfterBreak {
                stop()
            } else {
                transition(to: .work)
            }
        }
    }
}
