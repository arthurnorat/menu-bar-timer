# MenuBarTimer

---

## English

A minimalist Pomodoro timer that lives entirely in the macOS menu bar — no Dock icon, no extra windows.

### How it works

The timer follows the Pomodoro technique: focused work intervals separated by short breaks, with a longer break after every N cycles.

**Menu bar button**
- Shows a live countdown while running, or the full work duration when idle
- **Left click** — start a session when idle; pause or resume when running
- **Right click** — open or close the settings panel

**Settings panel**
- Work interval length
- Short and long rest durations
- Number of work intervals before a long rest
- Option to stop automatically after the break
- Din volume
- Show/hide the countdown in the menu bar
- Global keyboard shortcut to start/stop
- Launch at login toggle

**Cycle flow**
```
work → short rest → work → short rest → … → long rest → idle
```

### Requirements

- macOS 13 Ventura or later
- Xcode 15 or later (to build from source)

### Dependencies

| Package | Purpose |
|---|---|
| [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts) | Global hotkey for start/stop |
| [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin-Modern) | Login item management |

### Build

Open `MenuBarTimer.xcodeproj` in Xcode and press `⌘ R`.

---

## Português

Um timer Pomodoro minimalista que vive inteiramente na barra de menus do macOS — sem ícone no Dock, sem janelas extras.

### Como funciona

O timer segue a técnica Pomodoro: intervalos de foco separados por pausas curtas, com uma pausa longa após cada N ciclos completos.

**Botão na barra de menus**
- Exibe a contagem regressiva em tempo real durante a sessão, ou a duração total do intervalo de trabalho quando ocioso
- **Clique esquerdo** — inicia uma sessão quando ocioso; pausa ou retoma quando em andamento
- **Clique direito** — abre ou fecha o painel de configurações

**Painel de configurações**
- Duração do intervalo de trabalho
- Duração das pausas curta e longa
- Número de intervalos de trabalho antes da pausa longa
- Opção de parar automaticamente após a pausa
- Volume do sinal sonoro
- Exibir/ocultar a contagem na barra de menus
- Atalho de teclado global para iniciar/parar
- Opção para iniciar junto com o sistema

**Fluxo de ciclos**
```
trabalho → pausa curta → trabalho → pausa curta → … → pausa longa → ocioso
```

### Requisitos

- macOS 13 Ventura ou superior
- Xcode 15 ou superior (para compilar a partir do código-fonte)

### Dependências

| Pacote | Finalidade |
|---|---|
| [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts) | Atalho global para iniciar/parar |
| [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin-Modern) | Gerenciamento do item de login |

### Compilar

Abra `MenuBarTimer.xcodeproj` no Xcode e pressione `⌘ R`.
