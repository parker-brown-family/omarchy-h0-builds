# How h0 built Disk Free

h0 (a coding-agent harness) running Claude Opus 5.5 (claude-opus-5-5), fitting `none`, in a sandbox holding a copy of an Omarchy 4 home directory. It was sent the idea below, then, after each reply, the same automatic checks ran; when one failed, the next prompt was written from a fixed template from what the check printed, the way a person pastes back an error. Nobody edited its files. The protocol is in the omarchy-h0-builds repository.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 26 | 773,411 | 11,948 | $0.63 | 2.1 | all pass |
| **all** | | **26** | | | **$0.63** | **2.1** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that shows how much free space is left on my main drive in the top bar, like "182G free". Have it update every minute or so, and turn the text red when less than 10% is left.
```

26 turns, $0.63, 125 s. Stop: `end_turn`.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.disk-free
- ✓ `validate`
- ✓ `loads`: plugin parker.disk-free  (~/.config/omarchy/plugins/parker.disk-free)
- ✓ `switched-on`: id parker.disk-free
- ✓ `shows-size`:   barWidget: DiskFree.qml: loaded; drew: 122G free

<details><summary>h0's reply</summary>

I've built the disk-free plugin and added it to the right side of your top bar. It shows something like `122G free`, checks every 60 seconds, and turns red when less than 10% of the drive is left. I haven't seen it running in your actual bar, though: the shell can't run in my sandbox.

**What it does**
- It reads free space on `/` and counts only the space you can actually use. The number is rounded the same way `df -h` shows it: `182G`, or `9.4G` below 10.
- The red is your theme's `red` color. In the ember theme that's `#f38ba8`, a pinkish red.
- Hovering shows the details, e.g. "122G free of 952G (12.8%) on /".
- Clicking it refreshes right away.
- On a left or right side bar it shows just `122G`, because "free" doesn't fit.
- You can change the drive, the timing and the red threshold in its entry in `shell.json`, e.g. `{ "id": "parker.disk-free", "interval": 120, "warnPercent": 15 }`.

**Files**
- `~/.config/omarchy/plugins/parker.disk-free/`
  - `manifest.json`: describes the plugin to Omarchy.
  - `DiskFree.qml`: the bar widget.
  - `Model.js`: reads the disk numbers and formats the text.
- `~/.config/omarchy/shell.json`: one line added to put the widget first in the right section.

**Testing**
- Omarchy's own plugin checker (`omarchy plugin validate`) passes, and `shell.json` is still valid.
- I ran the reading, formatting and under-10% logic in Qt's QML engine against your real drive. It gave `122G free`, 12.8% left, so not red, which matches `df -h /`. Tests for rounding, the 10% boundary and bad input all passed.
- The QML checker (`qmllint`) found no real problems. Its remaining warnings come from Omarchy shell imports the checker can't find, and a built-in Omarchy widget shows the same kind. Fixing those warnings found one real bug: the widget file was named after the type it builds on, so I renamed it to `DiskFree.qml`.

**Not checked**
- How it looks and behaves in the bar.
- Whether it actually turns red there. Your drive is above 10%, so you won't see red yet.

The shell normally picks up new plugins and `shell.json` changes on its own. If the widget doesn't appear, run `omarchy-shell shell rescanPlugins`.

I deleted a stray `.local/` folder that a failed attempt to run `node` had created in the project.

</details>

Every tool call and its result: [SESSION.md](SESSION.md). The hash-chained trace: [session/trace.jsonl](session/trace.jsonl).
