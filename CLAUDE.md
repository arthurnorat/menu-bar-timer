# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Build & Run

This is a macOS-only SwiftUI app. There is no CLI build — use Xcode exclusively:

- **Run in development**: `⌘ R` in Xcode (builds in Debug, attaches debugger)
- **Release build**: Edit Scheme → Run → Build Configuration: Release → `⌘ B`
- **No tests exist** in this project

## Architecture

The app is a menubar-only timer (no Dock icon, no standard window). Entry point is `MenuBarTimerApp` in `App.swift`, which uses `@NSApplicationDelegateAdaptor` to delegate lifecycle to `StatusBarController`.

### Data flow

```
StatusBarController (App.swift)
  └── NSPanel  ←→  TimerPanelView (View.swift)
                        └── TimerController (Timer.swift)   ← owns all state
                                ├── TimerState (enum)       ← native state machine
                                ├── SoundPlayer    (Player.swift)
                                └── NotificationManager (Notifications.swift)
```

### Key design decisions

**Native state machine.** `TimerState` is a plain Swift `enum` with cases `idle`, `work`, `rest`. Transitions happen via a `transition(to:)` method in `TimerController` — no external library. Side effects (sounds, notifications) are triggered inside `transition(to:)` via a `switch`.

**No quasi-singleton.** `StatusBarController` holds a reference to `TimerController` directly. `TimerPanelView` receives it via `@EnvironmentObject`. No `TimerController.shared`.

**Mouse interaction split:**
- Left click → start from idle, or pause/resume if running
- Right click → toggles the `NSPanel`

**Pause is implemented without state changes.** `DispatchSourceTimer.suspend()` / `.resume()` freeze the underlying timer. `stopTimer()` must call `timer.resume()` before `cancel()` if `isPaused == true` — hard requirement of the `DispatchSource` API.

**`NSPanel` for the settings panel.** Uses `styleMask: [.borderless, .nonactivatingPanel]`, transparent background, `isMovableByWindowBackground = true`. Positioned below the menubar button via `convertToScreen()`. A global `NSEvent` monitor closes it on outside clicks.

**Menubar shows countdown text.** The button always shows a time string: remaining time while active, full work duration when idle.

### What this project intentionally excludes

- No JSON event log
- No URL scheme handler
- No GitHub Actions workflow or `export_options.plist`

### SPM dependencies

| Package | Purpose |
|---|---|
| `KeyboardShortcuts` (sindresorhus) | Global hotkey for start/stop |
| `LaunchAtLogin` (sindresorhus) | Login item management |

### Persistence

All user preferences use `@AppStorage` (backed by `UserDefaults`). Keys: `workIntervalLength`, `shortRestIntervalLength`, `longRestIntervalLength`, `workIntervalsInSet`, `stopAfterBreak`, `showTimerInMenuBar`, `dingVolume`.

### Planned features

1. Pomodoro cycle: `work → short rest → (every N cycles) long rest → idle`
2. Pause/resume without resetting
3. Session history (how many pomodoros today)
4. Focus label ("what am I working on?")
5. Multiple saved presets
6. Menubar text color changes with state (work / rest / idle)

## Git workflow

**Claude never runs git commands.** All commits, pushes, and git operations are performed by the user. Claude only edits and creates files.

### Setup checklist

- [ ] 1. `git init` in the project root
- [ ] 2. Create remote repo on GitHub and connect it
- [ ] 3. First commit: project template + CLAUDE.md (as-is, no code yet)
- [ ] 4. Add SPM dependencies in Xcode (`KeyboardShortcuts`, `LaunchAtLogin`)
- [ ] 5. Second commit: dependencies only (`project.pbxproj` + `Package.resolved`)
- [ ] 6. Claude writes the Swift source files (`App.swift`, `Timer.swift`, `View.swift`, `Player.swift`, `Notifications.swift`)
- [ ] 7. Third commit: application code

**Why this order:** each step gets an isolated commit, making the history readable and each change reversible independently.

### Current state
Steps 1–5 not yet done. SPM dependencies have not been added. Do not assume they are available until confirmed by the user.

## Project identity

- **Bundle Identifier**: `com.arthurnorat.MenuBarTimer`
- **Git remote**: to be defined after repo creation
