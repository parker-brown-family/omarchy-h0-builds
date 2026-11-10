# Claude Code building Disk Free

Claude Code 2.1.296 as shipped, with the Omarchy skill Omarchy installs, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 15 | 648,804 | 5,723 | $0.43 | 1.9 | all pass |
| **all** | | **15** | | | **$0.43** | **1.9** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that shows how much free space is left on my main drive in the top bar, like "182G free". Have it update every minute or so, and turn the text red when less than 10% is left.
```

15 model calls, $0.43, 113 s. Effort sent: medium.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.disk-free
- ✓ `validate`
- ✓ `loads`: plugin parker.disk-free  (~/.config/omarchy/plugins/parker.disk-free)
- ✓ `switched-on`: id parker.disk-free
- ✓ `shows-size`: barWidget: DiskFree.qml: loaded; drew: 117G free

<details><summary>The harness's reply</summary>

I built the plugin and added it to the right side of your bar. I couldn't see it running, because the Omarchy shell (the program that draws the bar) isn't running in this session. It should load the next time the shell starts. If it doesn't show up, run `omarchy restart shell`.

**What it shows:** "117G free" for your drive right now (117G of 952G, about 12%). The number matches what `df -h` reports. It updates every 60 seconds. When free space drops below 10%, the text turns your theme's warning color, which is red in most themes but not a pure red in every one. Hovering shows the full details, like "117G of 952G free on / (12%)".

**Testing:** I only checked the pieces separately, not the widget on a real bar.
- The config files are valid.
- The QML syntax check found no errors. Its warnings came from Omarchy's own code it couldn't find outside the shell.
- I tested the size formatting against your actual drive numbers, and it gives 117G and 952G, the same as `df -h`.

**Files:**
- `~/.config/omarchy/plugins/parker.disk-free/manifest.json` registers the plugin with the shell.
- `~/.config/omarchy/plugins/parker.disk-free/DiskFree.qml` contains the widget itself.
- `~/.config/omarchy/shell.json` now lists `parker.disk-free` first in the right section, before the tray. I saved a backup of the old file as `shell.json.bak.<timestamp>` in the same folder.

**Settings:** you can change these in that `shell.json` entry, and saving reloads the bar:
- `path`: which drive to watch (default `/`).
- `interval`: seconds between updates (default 60).
- `lowPercent`: when the text turns red (default 10).

You can also add it a second time with a different `path` to watch another drive.

**Unrequested addition:** clicking the widget refreshes it right away and opens btop. If you'd rather it didn't open btop, remove that line from `DiskFree.qml`. To move the widget, use `omarchy bar move parker.disk-free --section <left|center|right>`.

</details>

Every step: [SESSION.md](SESSION.md).
