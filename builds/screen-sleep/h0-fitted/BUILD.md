# h0 + Omarchy fitting building Screen Sleep

h0 with its Omarchy fitting (omarchy-v4), on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 18 | 418,181 | 6,414 | $0.39 | 1.3 | all pass |
| **all** | | **18** | | | **$0.39** | **1.3** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that turns my screens off after 10 minutes of no input and turns them back on when I touch the mouse or keyboard. It must never suspend the machine, because I leave agents running overnight.
```

18 model calls, $0.39, 80 s.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.screen-sleep
- ✓ `validate`
- ✓ `loads`: plugin parker.screen-sleep  (~/.config/omarchy/plugins/parker.screen-sleep)
- ✓ `switched-on`: id parker.screen-sleep
- ✓ `dpms-never-suspend`: read from the code

<details><summary>The harness's reply</summary>

I built the plugin as a background service called `parker.screen-sleep` and turned it on in your config. It passes the project's checks, which validate it and load it offscreen, but it hasn't run on your real desktop yet. Also, your current settings will lock and blank your screens at about 5 minutes, before this plugin's 10 minutes come up (details below).

**What changed**
- `.config/omarchy/plugins/parker.screen-sleep/manifest.json` and `Service.qml`: after 600 seconds (10 minutes) with no input, it runs `omarchy-brightness-display off`, which turns all monitors off. When you move the mouse or press a key, Hyprland turns them back on through its built-in settings for this. The plugin also runs `omarchy-brightness-display on` as a backup, which does nothing if the screens are already on.
- Like Omarchy's own idle service, it holds off while something is blocking idle (such as a playing video) or while the "Stay awake" toggle is on.
- **It never suspends.** It only switches the displays' power and never calls `systemctl suspend` or anything like it.
- `.config/omarchy/shell.json`: added `{"id": "parker.screen-sleep"}` to `plugins`, which is how your own services get turned on. There's a timestamped backup next to it.

**Checks:** `build` passed (JSON syntax, Omarchy's plugin validator, and the offscreen load). I couldn't test real idle detection or turning the screens off and on, because that needs your running desktop. To try it, run `omarchy-shell shell rescanPlugins`, then `omarchy-shell screen-sleep status` to see its state.

**Things you should know**
1. **Your current lock settings come first.** `shell.json` has `idle.lock: 300`, and Omarchy's lock screen blanks the displays about 5 seconds after locking. So right now your screens go dark at about 5 minutes, before this plugin does anything. If you want them lit until 10 minutes, raise `idle.lock` to `600` or more. I didn't change it because it's a security setting. Locking doesn't suspend, so your agents keep running either way.
2. **Nothing else here suspends on idle.** Omarchy doesn't, and `/etc/systemd/logind.conf` has `IdleAction` left at its default of `ignore`. However, `HandleLidSwitch` is also at its default, which is **suspend**. On a laptop, closing the lid will suspend the machine and pause your agents. Changing that is a system file that needs root, so I left it alone. If you want it, set `HandleLidSwitch=ignore` in a drop-in file under `/etc/systemd/logind.conf.d/`.
3. To change the timeout, edit `timeoutSeconds` in `Service.qml`. Saving the file reloads the plugin automatically.

</details>

Every step: [SESSION.md](SESSION.md).
