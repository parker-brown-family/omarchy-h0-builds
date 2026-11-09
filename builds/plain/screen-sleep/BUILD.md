# How h0 built Screen Sleep

h0 (a coding-agent harness) running Claude Opus 5.5 (claude-opus-5-5), fitting `none`, in a sandbox holding a copy of an Omarchy 4 home directory. It was sent the idea below, then, after each reply, the same automatic checks ran; when one failed, the next prompt was written from a fixed template from what the check printed, the way a person pastes back an error. Nobody edited its files. The protocol is in the omarchy-h0-builds repository.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 24 | 691,037 | 10,830 | $0.58 | 2.2 | all pass |
| **all** | | **24** | | | **$0.58** | **2.2** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that turns my screens off after 10 minutes of no input and turns them back on when I touch the mouse or keyboard. It must never suspend the machine, because I leave agents running overnight.
```

24 turns, $0.58, 135 s. Stop: `end_turn`.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.screen-sleep
- ✓ `validate`
- ✓ `loads`: plugin parker.screen-sleep  (~/.config/omarchy/plugins/parker.screen-sleep)
- ✓ `switched-on`: id parker.screen-sleep
- ✓ `dpms-never-suspend`: read from the code

<details><summary>h0's reply</summary>

I built the plugin and enabled it. One thing to know first: **your current settings already turn the screens off at about 5 minutes, not 10.** `shell.json` locks the screen at 300 seconds (5 minutes), and the built-in lock screen turns the displays off 5 seconds after it locks. The new plugin doesn't change that. If you want the screens to stay on for the full 10 minutes, change `idle.lock` to `600` or more. I left it alone because it's a security setting and you didn't ask me to change it.

**What I added**
- **`.config/omarchy/plugins/parker.screen-sleep/`**: a headless shell plugin (`manifest.json` + `Service.qml`).
  - After 600 seconds with no keyboard, mouse or touch input, it turns all displays off using Omarchy's own `omarchy-brightness-display off`.
  - The next input turns them back on. Hyprland already wakes the screens on any key press or mouse movement (Omarchy's defaults); the plugin also sends its own "on" as a backup.
  - It respects things that hold the screen on, like video playback, and Omarchy's "Stay awake" toggle.
  - It only switches display power. Nothing in it calls `systemctl`, suspend or hibernate, so the machine and your agents keep running.
  - You can control it from the command line: `omarchy-shell screen-sleep status`, `... on`, and `... off`. After a manual `off`, your next input wakes the screens through Hyprland, not the plugin.
- **`.config/omarchy/shell.json`**: added `{"id": "parker.screen-sleep"}` to `plugins`, which is how a user plugin gets turned on. The shell reloads this automatically. If it doesn't pick it up, run `omarchy-shell shell rescanPlugins`.
- **Changing the timeout**: edit `timeoutSeconds` in `Service.qml`. Omarchy doesn't let user plugins of this type read settings from `shell.json`, so it's set in the code. Saving the file reloads the plugin.

**Suspend:** none of Omarchy's own idle features suspend, and your login settings (logind) don't set an idle suspend. Choosing Suspend from the menu or closing a laptop lid would still suspend; the plugin doesn't block those. I can make it block all suspends while it runs, but that would also stop a closed lid from suspending.

**How I checked it**
- Both JSON files parse with `jq`.
- `qmllint` passes. It gives two warnings about the shape of the `onExited` handlers, which shouldn't affect how it runs.
- I ran the screen-off command with a stand-in for the brightness tool. It turns the screens off normally, does nothing when "Stay awake" is on, and still turns them off for a manual `off`.

**Not tested:** I couldn't run it in your real session, because the sandbox has no Hyprland or running shell. So I haven't seen it actually turn the screens off and on. To check it yourself, run `omarchy-shell shell listPlugins` to confirm it loaded, then `omarchy-shell screen-sleep status`. For a quick test, set `timeoutSeconds` to something like 30 for a minute, then set it back.

</details>

Every tool call and its result: [SESSION.md](SESSION.md). The hash-chained trace: [session/trace.jsonl](session/trace.jsonl).
