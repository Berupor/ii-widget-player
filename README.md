# Player widget

Media popup for the [illogical-impulse extensions
fork](https://github.com/Berupor/dots-hyprland-extensions). It takes the
`mediaView` slot, so the popup that opens from the bar's media pill shows this
instead of one card per player.

![Hero and list](docs/hero.png)

The popup is a list of players on the shell's own surface. The active one is
opened up on a card tinted from its cover, with its controls; every other player
is a row under it. Click a row to bring that player forward: it also becomes the
shell's tracked player, so the bar follows it once nothing else is playing. The
button at the end of a row plays or pauses that player without bringing it
forward.

The card follows the shell's own player cards: the blurred cover under a tint
mixed from it, the wallpaper colors when there is no cover. The app icon next to
the artist can be turned off in the widget's settings; the app name then follows
the artist.

## Install

Paste the repo url on the Widgets page. Needs contract 1.10 (`mediaView`).
Remote covers are fetched with `curl` into the shell's cover cache, the same one
the built-in popup uses.

## Files

| File | What it is |
|---|---|
| `MediaView.qml` | slot entry: picks the hero player |
| `hero.js` | which player goes up front, the last card color per cover |
| `HeroView.qml` | the list and the hero card, fed plain lists so the demo can drive it |
| `Backdrop.qml` | card surface: the tint over the blurred cover |
| `PlayerArt.qml`, `CoverArt.qml` | cover with a fallback glyph, remote art cached to a file |
| `CoverTint.qml` | color scheme off the cover, mixed like the shell's player cards |
| `demo/DemoPlayer.qml` | stub players for the checks and the shots in `docs/` |
