# opencode building Screen Sleep

opencode 2.0.28 as shipped, with the Omarchy skill Omarchy installs, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 21 | 684,882 | 8,364 | $0.53 | 1.5 | failed: dpms-never-suspend |
| 2 | follow-up | 4 | 200,712 | 3,117 | $0.13 | 0.6 | all pass |
| **all** | | **25** | | | **$0.66** | **2.0** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that turns my screens off after 10 minutes of no input and turns them back on when I touch the mouse or keyboard. It must never suspend the machine, because I leave agents running overnight.
```

21 model calls, $0.53, 90 s. Effort sent: None.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.screen-sleep
- ✓ `validate`
- ✓ `loads`: plugin parker.screen-sleep  (~/.config/omarchy/plugins/parker.screen-sleep)
- ✓ `switched-on`: id parker.screen-sleep
- ✗ `dpms-never-suspend`: read from the code

<details><summary>The harness's reply</summary>

I've built the plugin and turned it on, but I haven't seen it work yet. Hyprland and the Omarchy shell aren't running in this environment. Both files passed their syntax checks.

**Files**
- `~/.config/omarchy/plugins/parker.screen-sleep/manifest.json`
- `~/.config/omarchy/plugins/parker.screen-sleep/Service.qml`
- `~/.config/omarchy/shell.json`: I added `parker.screen-sleep` to `plugins` to turn it on.

**What it does**
- After 600 seconds (10 minutes) with no input, it turns the screens off with `omarchy brightness display off`.
- On the next keypress or mouse movement, it turns them back on with `omarchy brightness display on`. Hyprland's own setting to wake the screens on input is also on, as a backup.
- It only switches the screens on and off. It never suspends, hibernates or locks, so your agents keep running.
- It respects apps that ask to keep the screen awake, such as fullscreen video, and Omarchy's "stay awake" toggle.
- To change the 10 minutes, edit `timeoutSeconds` in `Service.qml`. The shell reloads it when you save.

**To check it's working:** run `omarchy-shell shell rescanPlugins`, then `omarchy-shell screen-sleep status`.

**Three things you should know:**
1. **Your current settings will lock and blank the screen first.** `shell.json` has `idle.lock: 300`, so after 5 minutes Omarchy locks the screen and turns it off about 5 seconds later. That still won't suspend the machine. If you want the screens to stay on, unlocked, until the 10-minute mark, raise or remove `idle.lock` (and `idle.screensaver`, which is 150 seconds). Tell me if you want that.
2. **Closing the lid will still suspend the machine.** It looks like a laptop, and by default closing the lid suspends it, which would pause your agents. Nothing on this system is set to suspend when you're simply idle, and hypridle isn't installed. If you'll close the lid overnight, setting `HandleLidSwitch=ignore` in a `/etc/systemd/logind.conf.d/` file would stop that. It needs sudo, so I haven't done it.
3. **Your stock `ember` theme files show as deleted in git.** That was already the case before I started, and I didn't touch them.

</details>

## Prompt 2

```text
It's not working yet: I can't see where it turns the screens off through Hyprland's DPMS, or it can suspend the machine.

read from the code
```

4 model calls, $0.13, 33 s. Effort sent: None.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.screen-sleep
- ✓ `validate`
- ✓ `loads`: plugin parker.screen-sleep  (~/.config/omarchy/plugins/parker.screen-sleep)
- ✓ `switched-on`: id parker.screen-sleep
- ✓ `dpms-never-suspend`: read from the code

<details><summary>The harness's reply</summary>

You were right that the code didn't show it. The plugin called `omarchy-brightness-display`, and the Hyprland DPMS call was hidden inside that script. I've changed the plugin to call `hyprctl` directly, so you can read it all in `~/.config/omarchy/plugins/parker.screen-sleep/Service.qml`. The new version passes the syntax check, but I still haven't run it: Hyprland and the shell aren't running here.

**How the screens turn off and on**

1. **Detecting idle:** `IdleMonitor` (line 45) asks Hyprland to report when there's been no input for `timeout: root.timeoutSeconds`, which is 600 seconds.
2. **Screens off:** after 10 minutes, it calls `screensOffNow()`, which runs:
   ```
   hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'
   ```
   It skips this if Omarchy's "stay awake" toggle is on.
3. **Screens on:** the next keypress or mouse movement ends the idle state and calls `screensOnNow()`, which runs:
   ```
   hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'
   ```
   It skips this if the screens are already on, because an unneeded "enable" makes them flicker. The Omarchy script had this check, so I copied it in. Hyprland's own wake-on-input settings are also on, as a backup.

**Why it can't suspend**

The plugin only ever runs the two `hyprctl dispatch ... dpms` commands above. Searching both plugin files for `suspend`, `hibernate`, `systemctl`, `loginctl` and `poweroff` finds them only in the description and comments, never in code that runs. DPMS just switches the screens' power off and on, so the machine and your agents keep running. I also stopped the commands from starting a login shell (`bash -c` instead of `bash -lc`), so your shell profile scripts can't run anything extra.

**To test it:** run `omarchy-shell shell rescanPlugins`, then `omarchy-shell screen-sleep status`. To test faster, temporarily set `timeoutSeconds` to `30`.

Two things from before still apply. Your current settings lock the screen after 5 minutes (`idle.lock: 300`) and blank it a few seconds later, so the screens will go dark before this plugin's 10-minute mark. And closing the laptop lid will still suspend the machine unless you set `HandleLidSwitch=ignore`.

</details>

Every step: [SESSION.md](SESSION.md).
