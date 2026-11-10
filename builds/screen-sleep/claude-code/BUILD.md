# Claude Code building Screen Sleep

Claude Code 2.1.296 as shipped, with the Omarchy skill Omarchy installs, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 17 | 808,164 | 7,293 | $0.52 | 2.2 | failed: dpms-never-suspend |
| 2 | follow-up | 4 | 258,954 | 2,794 | $0.13 | 0.6 | all pass |
| **all** | | **21** | | | **$0.65** | **2.8** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that turns my screens off after 10 minutes of no input and turns them back on when I touch the mouse or keyboard. It must never suspend the machine, because I leave agents running overnight.
```

17 model calls, $0.52, 130 s. Effort sent: medium.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.screen-sleep
- ✓ `validate`
- ✓ `loads`: plugin parker.screen-sleep  (~/.config/omarchy/plugins/parker.screen-sleep)
- ✓ `switched-on`: id parker.screen-sleep
- ✗ `dpms-never-suspend`: read from the code

<details><summary>The harness's reply</summary>

I built the plugin and turned it on. The QML compiles and loads cleanly in a headless Quickshell. I couldn't test the actual screen-off/screen-on behavior, though, because this session has no running Hyprland or `omarchy-shell`. Confirming it on your desktop takes a minute; see the checks below.

**Files**
- `~/.config/omarchy/plugins/parker.screen-sleep/manifest.json` registers it as a background service in the Omarchy shell.
- `~/.config/omarchy/plugins/parker.screen-sleep/Service.qml` does the work. It uses the same Wayland idle detector as Omarchy's built-in idle service, set to 600 seconds:
  - **10 minutes with no input:** runs `omarchy-brightness-display off`, which turns the monitors off but leaves the machine running.
  - **Next mouse or keyboard input:** runs `omarchy-brightness-display on`.
  - The only thing it ever runs is that one command, with `off` or `on`. Nothing in it suspends, hibernates or locks.
  - It leaves the screens on during fullscreen video and while Omarchy's **Stay Awake** toggle is on.
  - If the plugin is reloaded or disabled while the screens are off, it turns them back on.
- `~/.config/omarchy/shell.json`: I added `{"id": "parker.screen-sleep"}` to `plugins[]`. The previous version is saved alongside it as `shell.json.bak.<timestamp>`.

**Nothing else on the system suspends on idle either**
- logind has no idle action set, so the default (do nothing) applies. Your only logind overrides are "ignore power button" and a 15-second inhibit delay.
- hypridle isn't running.
- Omarchy's built-in idle service only starts the screensaver (2.5 min) and locks (5 min). It never suspends.

So your agents will keep running overnight. Your existing lock still happens at 5 minutes, and the screens go dark at 10. Two things outside the plugin can still suspend the machine: choosing Suspend from the system menu, or a laptop lid-close if that's configured. Neither happens on idle.

**To check it on your desktop**
```bash
omarchy-shell screen-sleep status   # should print {"timeout":600,"idle":false,"screensOff":false,...}
```
If that says the target isn't found, run `omarchy-shell shell rescanPlugins` or `omarchy restart shell`. To watch it work without waiting 10 minutes, temporarily set `timeoutSeconds` to `15` in `Service.qml`. It reloads when you save. Then leave the mouse alone and wiggle it after the screens go off.

To change the delay later, edit `timeoutSeconds` in `Service.qml`.

</details>

## Prompt 2

```text
It's not working yet: I can't see where it turns the screens off through Hyprland's DPMS, or it can suspend the machine.

read from the code
```

4 model calls, $0.13, 37 s. Effort sent: medium.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.screen-sleep
- ✓ `validate`
- ✓ `loads`: plugin parker.screen-sleep  (~/.config/omarchy/plugins/parker.screen-sleep)
- ✓ `switched-on`: id parker.screen-sleep
- ✓ `dpms-never-suspend`: read from the code

<details><summary>The harness's reply</summary>

The plugin now calls Hyprland's DPMS directly, so you can read the screen-off step in the plugin itself. Before, it was hidden inside `omarchy-brightness-display`. I haven't watched the screens actually turn off and on, because this session has no Hyprland running. The change passes `qmllint` with no new warnings.

**Where the screens go off and on** (`Service.qml`):

- **Line 25:** the `dpms()` function runs `hyprctl dispatch 'hl.dsp.dpms({ action = "disable" | "enable" })'`. That's the same command Omarchy's own brightness script uses (`/usr/share/omarchy/bin/omarchy-brightness-display:63` and `:70`).
- **Lines 37–43:** the idle monitor waits 600 seconds. When you go idle, `setScreens(false)` calls `dpms("disable")`. Your next keyboard or mouse input calls `setScreens(true)`, which calls `dpms("enable")`.
- **Line 62:** if the plugin is reloaded or disabled while the screens are off, it calls `dpms("enable")` so they don't stay dark.

**Why it can't suspend:** the plugin can only run two commands:
- **Line 25:** `hyprctl dispatch` with the DPMS action, `disable` or `enable`. This only turns the monitor signal off or on; apps and agents keep running.
- **Line 49:** `test -e ~/.local/state/omarchy/indicators/stay-awake`, which only checks whether Stay Awake is on.

The code never mentions `systemctl`, `loginctl`, suspend, hibernate or lock; the only matches are the comment that says it never suspends and the IPC name `screen-sleep`.

**To check it on your desktop:**
```bash
hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'   # screens should go dark; move the mouse…
hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'    # …or run this to bring them back
omarchy-shell screen-sleep status                        # confirms the plugin is loaded
```
If `status` says the target isn't found, the shell hasn't loaded the plugin yet. Run `omarchy restart shell`. To test the full cycle without waiting 10 minutes, temporarily set `timeoutSeconds` (line 16) to `15`.

If you saw a specific failure, like screens not going off or the status command erroring, tell me what happened.

</details>

Every step: [SESSION.md](SESSION.md).
