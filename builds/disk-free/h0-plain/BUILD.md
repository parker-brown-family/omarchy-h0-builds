# h0, plain building Disk Free

h0 with no fitting, on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 30 | 959,239 | 11,987 | $0.67 | 3.6 | all pass |
| **all** | | **30** | | | **$0.67** | **3.6** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that shows how much free space is left on my main drive in the top bar, like "182G free". Have it update every minute or so, and turn the text red when less than 10% is left.
```

30 model calls, $0.67, 217 s.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.disk-free
- ✓ `validate`
- ✓ `loads`: plugin parker.disk-free  (~/.config/omarchy/plugins/parker.disk-free)
- ✓ `switched-on`: id parker.disk-free
- ✓ `shows-size`: barWidget: DiskFree.qml: loaded; drew: 116G free

<details><summary>The harness's reply</summary>

I built the disk-space plugin and added it to your top bar. It shows how much space is free on your main drive (`/`), like "116G free", checks again every 60 seconds, and turns the theme's red when less than 10% is left. I tested it inside Quickshell but haven't seen it on your actual bar: the shell isn't reachable from my sandbox, so I couldn't reload it there.

**What changed**
- **The plugin:** a new folder, `~/.config/omarchy/plugins/parker.disk-free/`, with two files:
  - `manifest.json` describes the plugin. It passes `omarchy plugin validate`.
  - `DiskFree.qml` is the widget itself. It reads free space with `df` every 60 seconds and shows it in gigabytes (or "1.2T" above 1024G). Hovering shows a tooltip like `/: 116G free of 951G (12% free)`. Clicking it re-checks right away.
- **The bar:** in `~/.config/omarchy/shell.json` I added one line to put the widget first in the right section, just before the tray. That line is also what turns it on.
- **Settings:** you can change these in its entry in `shell.json` if you want, for example `{"id": "parker.disk-free", "lowPercent": 15}`:
  - `path` – which drive to watch (default `/`)
  - `intervalSec` – seconds between checks (default 60)
  - `lowPercent` – the % free where it turns red (default 10)

**How I tested it**
- I loaded the real widget in Quickshell, using Omarchy's own building blocks for bar widgets.
- With the default settings it showed `116G free` in normal color. Your drive is at 12% free, which matches `df`. `df -h` says 117G only because it rounds up.
- With the red threshold set to 50% it turned red, so the warning works.
- The only warnings from the QML checker were about Omarchy's internal imports, which Quickshell provides when the shell runs. The built-in widgets use the same imports.

**Worth knowing**
- **To see it:** the shell normally picks up new plugins automatically. If it doesn't appear, run `omarchy-shell shell rescanPlugins` or `omarchy restart shell`.
- **The 10% rule** compares free space to the drive's full size, so it's measured the same way as the number shown.
- **Unrelated:** git shows the `~/.config/omarchy/themes/ember/` theme files as deleted. They were already missing before I started, and I didn't touch them.
- **Cleanup:** I deleted my temporary test folder, plus a `.local/` folder that the tool manager mise created when I tried to run `node`.

</details>

Every step: [SESSION.md](SESSION.md).
