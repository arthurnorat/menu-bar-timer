🇺🇸 [English](#english) · 🇧🇷 [Português](#português)

---

<a name="english"></a>

# ⏱️ MenuBarTimer

A minimalist Pomodoro timer that lives entirely in the macOS menu bar — no Dock icon, no extra windows.

## About

MenuBarTimer follows the Pomodoro technique: focused work intervals separated by short breaks, with a longer break after every N cycles. Everything is controlled from the menu bar — no window ever takes over your screen.

## Features

**Menu bar button**
- Shows a live countdown while running, or the full work duration when idle
- **Left click** — start a session when idle; pause or resume when running
- **Right click** — open or close the settings panel

**Settings panel**
- Work interval length
- Short and long rest durations
- Number of work intervals before a long rest
- Option to stop automatically after the break
- Ding volume
- Show/hide the countdown in the menu bar
- Launch at login toggle
- Quit button

**Cycle flow**
```
work → short rest → work → short rest → … → long rest → idle
```

## Requirements

- macOS 13 Ventura or later

## Dependencies

| Package | Purpose |
|---|---|
| [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin-Modern) | Login item management |

---

<a name="português"></a>

# ⏱️ MenuBarTimer

Um timer Pomodoro minimalista que vive inteiramente na barra de menus do macOS — sem ícone no Dock, sem janelas extras.

## Sobre

O MenuBarTimer segue a técnica Pomodoro: intervalos de foco separados por pausas curtas, com uma pausa longa após cada N ciclos completos. Tudo é controlado pela barra de menus — nenhuma janela toma conta da sua tela.

## Funcionalidades

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
- Opção para iniciar junto com o sistema
- Botão para encerrar o app

**Fluxo de ciclos**
```
trabalho → pausa curta → trabalho → pausa curta → … → pausa longa → ocioso
```

## Requisitos

- macOS 13 Ventura ou superior

## Dependências

| Pacote | Finalidade |
|---|---|
| [LaunchAtLogin](https://github.com/sindresorhus/LaunchAtLogin-Modern) | Gerenciamento do item de login |
