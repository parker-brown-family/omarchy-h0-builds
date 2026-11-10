# h0 + Omarchy fitting building Disk Free

h0 with its Omarchy fitting (omarchy-v4), on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 11 | 212,412 | 4,253 | $0.27 | 1.1 | all pass |
| **all** | | **11** | | | **$0.27** | **1.1** | |

## Prompt 1

```text
Build me an Omarchy shell plugin that shows how much free space is left on my main drive in the top bar, like "182G free". Have it update every minute or so, and turn the text red when less than 10% is left.
```

11 model calls, $0.27, 64 s.

Checks after it:

- ✓ `found`: .config/omarchy/plugins/parker.disk-free
- ✓ `validate`
- ✓ `loads`: plugin parker.disk-free  (~/.config/omarchy/plugins/parker.disk-free)
- ✓ `switched-on`: id parker.disk-free
- ✓ `shows-size`: barWidget: BarWidget.qml: loaded; drew: 116G free

<details><summary>The harness's reply</summary>

I built the plugin and added it to the right side of your bar, just left of the brightness/display widget. In the offscreen preview it showed **"116G free"** for your root drive.

**What it does**
- Every 60 seconds it runs `df` on `/` and shows the free space, like "116G free". When the bar is vertical it drops the word "free" to save room.
- When less than 10% is left, the text turns your theme's red color.
- Hovering shows a tooltip with the free space, total size and percentage. Clicking refreshes it straight away.
- In `shell.json` you can change which drive it watches (`path`), how often it updates in seconds (`interval`) and the red threshold (`warnPercent`).

**Files**
- New: `.config/omarchy/plugins/parker.disk-free/manifest.json` and `BarWidget.qml`.
- Edited: `.config/omarchy/shell.json`, where I added one entry to the right section of the bar. A backup was saved first as `shell.json.bak.<timestamp>`.

**Checks**
- The project's `build` check passed: the JSON is valid, Omarchy's plugin validator accepted it, and the plugin loaded in Quickshell and drew its text.
- I compared the number against `df`: 124,907,438,080 bytes free out of 952G, which is **116G**. `df -h` shows 117G only because it rounds up.

**Not checked**
- I didn't see the red text, because your drive isn't below 10%. It's **about 12% free**, so the text will turn red after roughly another 20G is used. To test it now, temporarily set `"warnPercent": 50` on the entry in `shell.json`.
- I couldn't check it on your running desktop from here. The shell should pick it up on its own; if the widget doesn't appear, run `omarchy-shell shell rescanPlugins`.

</details>

Every step: [SESSION.md](SESSION.md).
