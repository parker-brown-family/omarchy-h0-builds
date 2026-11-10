# h0 + Omarchy fitting building Paper Lantern

h0 with its Omarchy fitting (omarchy-v4), on Claude Opus 5.5, in a sandbox holding a copy of an Omarchy 4 home directory with the network off. After each reply the same checks ran for every harness; a failed check became the next prompt, written from a fixed template. Nobody edited the files.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 28 | 927,509 | 17,628 | $0.77 | 4.3 | all pass |
| **all** | | **28** | | | **$0.77** | **4.3** | |

## Prompt 1

```text
Make me a light Omarchy theme called Paper Lantern: a warm off-white paper background, ink-black text, and a red lantern accent. Include a matching background image, and theme btop and my keyboard lighting too.
```

28 model calls, $0.77, 256 s.

Checks after it:

- ✓ `found`: .config/omarchy/themes/paper-lantern
- ✓ `colors`
- ✓ `background`: 1-paper-lantern.jpg: 3840px
- ✓ `draws`: theme paper-lantern: drawn; drew: Mon 21:21 | Mon 21:21
- ✓ `btop.theme`
- ✓ `keyboard.rgb`

<details><summary>The harness's reply</summary>

I've created the Paper Lantern theme in `~/.config/omarchy/themes/paper-lantern/`, but haven't applied it. Run this to switch to it:

```bash
omarchy theme set "Paper Lantern"
```

**What's in it**
- **`colors.toml`**: a light palette, marked as light mode. The background is warm paper `#F4EDDF`, text is ink-black `#1C1915`, and the accent is lantern red `#B8322A`. The other colors are toned down so they read well on paper. Omarchy uses this file to color the terminals, Hyprland borders, the bar, Neovim and VS Code.
- **`btop.theme`**: a custom btop theme, ink on paper. Shortcut keys and selected rows are lantern red, and the CPU, download and process graphs go from amber to orange to red.
- **`keyboard.rgb`**: `ff3a1a`, a brighter version of the lantern red. The exact accent color would look dim and brown on LEDs.
- **`icons.theme`**: `Yaru-red` (it's installed). **`chromium.theme`**: matches the paper color.
- **`backgrounds/1-paper-lantern.jpg`**: 3840×2160. Textured off-white paper with a soft peach glow and a red lantern on the right third. It has ribs, black caps, a hanging string and a tassel.

**About the background:** the sandbox has no internet, so I couldn't download one and drew it with ImageMagick instead. It's a clean, flat illustration, not a photo. The script that makes it, `make-background.sh`, is in the theme folder, so you can change the colors or lantern position and run it again. You can also add any image to `backgrounds/`.

**Checks**
- The colors file and generator script pass the syntax checks, and the `build` check passes.
- Omarchy's own color reader loads the palette and sees it as a light theme.
- An offscreen preview drew the bar on the paper background.
- Text contrast against the paper: ink 15:1, lantern red 5.1:1, yellow lowest at 3.3:1.

**Not checked**
- I haven't seen it on your live desktop or looked at the background image itself; I only checked pixel colors. Please look at it after applying.
- Omarchy only sets keyboard lighting on ASUS ROG laptops (via `asusctl`) and Framework Laptop 16 (via `qmk_hid`). Other keyboards will ignore it.

</details>

Every step: [SESSION.md](SESSION.md).
