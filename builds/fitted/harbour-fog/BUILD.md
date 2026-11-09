# How h0 built Harbour Fog

h0 (a coding-agent harness) running Claude Opus 5.5 (claude-opus-5-5), fitting `omarchy-v4`, in a sandbox holding a copy of an Omarchy 4 home directory. It was sent the idea below, then, after each reply, the same automatic checks ran; when one failed, the next prompt was written from a fixed template from what the check printed, the way a person pastes back an error. Nobody edited its files. The protocol is in the omarchy-h0-builds repository.

| prompt | what was sent | turns | prompt tokens | output tokens | cost | minutes | checks after it |
|---|---|---|---|---|---|---|---|
| 1 | the idea | 27 | 737,804 | 15,281 | $0.79 | 13.5 | all pass |
| **all** | | **27** | | | **$0.79** | **13.5** | |

## Prompt 1

```text
Make me a new Omarchy theme called Harbour Fog: cool grey-blue, low contrast, easy on the eyes late at night, with a muted teal accent. Include a background image.
```

27 turns, $0.79, 812 s. Stop: `end_turn`.

Checks after it:

- ✓ `found`: .config/omarchy/themes/harbour-fog
- ✓ `colors`
- ✓ `background`: 1-harbour-fog.jpg: 3840px
- ✓ `draws`: theme harbour-fog: drawn; drew: Mon 15:41 | Mon 15:41

<details><summary>h0's reply</summary>

I created **Harbour Fog** at `~/.config/omarchy/themes/harbour-fog/`. It parses cleanly, shows up in `omarchy theme list`, and the bar preview draws in its colours. I haven't applied it to your desktop. To switch to it, run:

```
omarchy theme set "Harbour Fog"
```

**The colours** (`colors.toml`)
- **Background:** grey-blue `#232a31`, with darker and lighter shades of the same tone.
- **Text:** soft grey `#b3bdc7`. It contrasts with the background at about 7.6:1, where Nord is about 11:1, so it's gentler late at night and still easy to read.
- **Accent:** muted teal `#6fa3a0`.
- **Other colours:** red, yellow, green, blue and the rest are all toned down. None goes below about 4.8:1 contrast with the background, so they stay readable.

**Background image** (`backgrounds/1-harbour-fog.jpg`, 3840×2160)
The sandbox has no internet, so I couldn't download a photo. Instead I made an original image with ImageMagick: a harbour at night with fog over the water. Distant hills and a crane fade into the fog, and in front are a pier with posts, a moored sailboat, and two teal lamps reflected in the water. It only uses the theme's colours and is dark and soft overall. I checked it by sampling brightness and colour across the frame rather than viewing it, so have a look. If you'd prefer a real photo, drop more images into `backgrounds/` and switch between them with `omarchy theme bg next`.

**Other files**
- `icons.theme`: the `Yaru-prussiangreen` icon set, the teal-coloured Yaru option, to match the accent.
- `unlock.png`: the Omarchy logo recoloured teal, used for the boot screen.
- `preview.jpg` and `preview-unlock.png`: thumbnails for the theme and boot-screen pickers.
- Configs for your terminals, Neovim, btop, Hyprland borders and other apps are created automatically from `colors.toml` when you apply the theme, like the stock themes.

**Checks:** the `toml` and `build` checks pass, and `omarchy-theme-color` reads every colour and detects dark mode.

**Not checked:** I couldn't apply the theme in the sandbox, so I haven't seen it on the real desktop. If the text feels too faint after using it for a while, raise `foreground` in `colors.toml` slightly and run `omarchy theme set "Harbour Fog"` again.

</details>

Every tool call and its result: [SESSION.md](SESSION.md). The hash-chained trace: [session/trace.jsonl](session/trace.jsonl).
