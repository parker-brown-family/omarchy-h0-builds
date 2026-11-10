# h0, plain building Screen Sleep

h0 with no fitting, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 33 | 1,178,886 | 13,097 | $0.78 | 3.3 | failed: dpms-never-suspend |
| 2 | follow-up | 11 | 742,085 | 7,681 | $0.36 | 1.8 | all pass |
| **all** | | **44** | | | **$1.15** | **5.1** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that turns my screens off after 10 minutes of no input and turns them back on when I touch the mouse or keyboard. It must never suspend the machine, because I leave agents running overnight.
```

33 model calls, $0.78, 199 s.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.screen-sleep
- ✓ `validate`
- ✓ `loads`: plugin parker.screen-sleep  (~/.config/omarchy/plugins/parker.screen-sleep)
- ✓ `switched-on`: id parker.screen-sleep
- ✗ `dpms-never-suspend`: read from the code

<details><summary>The harness's reply</summary>

I built the plugin and turned it on. Its logic passes its tests and it loads cleanly in Quickshell, but I couldn't watch it turn real screens off and on, because there's no Hyprland session in my sandbox.

**One thing to fix first:** your stock idle settings will turn the screens off before 10 minutes. `shell.json` still has the screensaver at 150s (2.5 min) and the lock at 300s (5 min). The stock lock screen turns the displays off about 5 seconds after it locks, so right now they'd go dark at about 5 minutes. To make 10 minutes the real behavior, raise or remove `idle.lock` (and `idle.screensaver` if you want). I didn't change these without asking. Tell me and I'll do it.

**What it does** (`~/.config/omarchy/plugins/parker.screen-sleep/`)
- After 600 seconds with no keyboard or mouse input, it turns off every display and the keyboard backlight. It uses the same Omarchy commands the stock idle and lock use.
- At the next input it runs `omarchy-system-wake` to turn the displays back on. Hyprland is also set to wake displays on any key press or mouse move, so there are two paths back.
- It leaves the screens on while Omarchy's "stay awake" toggle is on, or while an app is blocking idle (for example, a fullscreen video). Turning stay-awake on while the screens are off wakes them.
- If the plugin is reloaded or turned off while the screens are dark, it turns them back on first.
- `omarchy-shell screen-sleep status` shows its current state.
- I added `{"id": "parker.screen-sleep"}` to `plugins` in `~/.config/omarchy/shell.json`, which turns it on. The shell reloads that file when it changes.

**Never suspending**
- The plugin only ever runs two commands, one to turn displays off and one to turn them on. Nothing in it can suspend or hibernate the machine.
- Nothing else in Omarchy suspends after idle time either.
- **Still possible:** suspending on purpose from the system menu, or closing a laptop lid, can still suspend the machine. That's outside this plugin. If you want those blocked too, I can run `omarchy toggle suspend` to take Suspend out of the menu, or block sleep entirely while the plugin runs.

**How I checked it**
- `test.mjs` checks the 10-minute timeout and every combination of idle and stay-awake. It also scans the plugin and the commands it calls for anything that could suspend. All tests pass.
- I loaded it in Quickshell without a display. It starts without errors and picks up the stay-awake setting.
- `qmllint` only gave the same type warning the stock idle service gets.
- To run the tests yourself: `node ~/.config/omarchy/plugins/parker.screen-sleep/test.mjs`. That's the full path to `node` on your machine; plain `node` tried to download a version and failed offline.

**Also found:** git shows the `ember` theme files in `~/.config/omarchy/themes/ember/` as deleted. They were already gone when I started, and I didn't touch them. I also removed some leftover `.local/state/mise` files that my `node` attempt created.

</details>

## Prompt 2

```text
It's not working yet: I can't see where it turns the screens off through Hyprland's DPMS, or it can suspend the machine.

read from the code
```

11 model calls, $0.36, 108 s.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.screen-sleep
- ✓ `validate`
- ✓ `loads`: plugin parker.screen-sleep  (~/.config/omarchy/plugins/parker.screen-sleep)
- ✓ `switched-on`: id parker.screen-sleep
- ✓ `dpms-never-suspend`: read from the code

<details><summary>The harness's reply</summary>

The plugin now calls Hyprland's DPMS directly, so you can see it in the code. It runs no shell and no Omarchy scripts.

**What the old code did:** it didn't call DPMS itself. It ran `omarchy-brightness-display off` through `bash`, and the actual DPMS call was two scripts down (`omarchy-brightness-display:63`). The wake command, `omarchy-system-wake`, also ran a monitor script that can reload Hyprland and change monitor settings. That's more than turning a screen back on. Nothing in that chain could suspend the machine, but you couldn't confirm that from the plugin's own code.

**Where to look now:**
- **The DPMS calls** (`ScreenSleepModel.js:13-14`), run directly by `Service.qml:52`:
  ```
  ["hyprctl", "dispatch", 'hl.dsp.dpms({ action = "disable" })']   // after 10 min idle
  ["hyprctl", "dispatch", 'hl.dsp.dpms({ action = "enable" })']    // on mouse/keyboard input
  ```
  These match the calls Omarchy's own scripts use.
- **Everything else it runs:** `mkdir -p` and `test -f` on the stay-awake file. I replaced the old `bash` command for that, so `bash` no longer appears anywhere in the plugin.
- I also dropped the keyboard backlight changes, since you didn't ask for them.

**Proof that it can't suspend:**
- `test.mjs` checks the exact DPMS arguments above. It also lists every process the service can start and fails if anything else is added. It fails on any shell, `systemctl`, `loginctl`, `suspend`, `hibernate`, `poweroff`, `/sys/power` or `omarchy-*` call.
- All tests pass. When I planted a `systemctl suspend` in a copy, the test caught it.
- I ran the service in Quickshell with a fake `hyprctl` that logged its arguments. It received only these three calls: the disable call, then the enable call when stay-awake turned on, then the enable call when the plugin was unloaded with screens off.

**What I couldn't check:** the idle trigger itself. There's no Hyprland in my sandbox, so the 10-minute timer never fired; I started the off and on paths by hand.

**Still true from before:**
- Your stock lock (`idle.lock: 300`) still turns the screens off at about 5 minutes. If you want me to change it, say so.
- Choosing Suspend in the system menu or closing a laptop lid can still suspend the machine, because that's handled outside this plugin.

</details>

Every step: [SESSION.md](SESSION.md).
