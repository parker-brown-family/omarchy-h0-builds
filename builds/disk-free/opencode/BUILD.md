# opencode building Disk Free

opencode 2.0.28 as shipped, with the Omarchy skill Omarchy installs, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 20 | 621,704 | 5,800 | $0.45 | 1.2 | all pass |
| **all** | | **20** | | | **$0.45** | **1.2** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that shows how much free space is left on my main drive in the top bar, like "182G free". Have it update every minute or so, and turn the text red when less than 10% is left.
```

20 model calls, $0.45, 72 s. Effort sent: None.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.disk-free
- ✓ `validate`
- ✓ `loads`: plugin parker.disk-free  (~/.config/omarchy/plugins/parker.disk-free)
- ✓ `switched-on`: id parker.disk-free
- ✓ `shows-size`: barWidget: DiskFree.qml: loaded; drew: 112G free

<details><summary>The harness's reply</summary>

I built the plugin and added it to the right side of your top bar, but I couldn't see it running. The Omarchy shell (the process that draws the bar) isn't running in this session. The plugin passes `omarchy plugin validate`, but it will only show up once the shell starts. Run `omarchy restart shell` or log back in. If it doesn't appear, run `omarchy-shell shell rescanPlugins`.

**Files**
- `~/.config/omarchy/plugins/parker.disk-free/manifest.json`: describes the plugin and its settings.
- `~/.config/omarchy/plugins/parker.disk-free/DiskFree.qml`: the bar widget.
- `~/.config/omarchy/shell.json`: I added the widget to the right side of the bar, just after the tray.

**What it does**
- Shows free space on `/`, like `112G free`. Drives of 1 TB or more show something like `1.2T free`.
- Checks again every 60 seconds. Middle-click checks right away.
- Turns red when less than 10% is left, using your theme's red so it matches the current theme.
- Hovering shows details, like `/: 112G of 951G free (12%)`.
- Left-click opens `btop`.

Your drive currently has about 112G free (12%), so the text will be normal-coloured for now but is close to turning red.

You can change the settings on the widget's entry in `shell.json`. The bar picks up changes as soon as you save.

```json
{ "id": "parker.disk-free", "path": "/", "intervalSec": 60, "warnPercent": 10 }
```

To move it, run something like `omarchy bar move parker.disk-free --section center`.

</details>

Every step: [SESSION.md](SESSION.md).
