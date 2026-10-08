# NetflixHD

Netflix on the TV: a frameless, full-screen window that opens straight into
Netflix, for an Omarchy machine plugged into a modern television. A sibling of
[YourTobaHD](https://github.com/FromChaosComesClarity/YourTobaHD), and made to
sit on the home screen of
[OMATVLauncher](https://github.com/FromChaosComesClarity/OMATVLauncher).

## Why not Electron, like YourTobaHD

Netflix plays only through **Widevine DRM**. Stock Electron does not ship
Widevine, so an Electron Netflix app shows a black player and an error; the
one way around it is castLabs' Widevine build of Electron, a separate and
heavier runtime to track for no gain on Linux. Chromium already has Widevine —
it downloads the module itself — so NetflixHD is a small launcher around
`chromium --app --kiosk`:

- **Its own profile** (`~/.local/share/netflixhd/profile`), so the Netflix login
  and settings stay out of the everyday browser.
- **Widevine ready on the first launch**: the module is copied from your
  existing Chromium (or Chrome, or Brave) profile, instead of the new profile
  waiting minutes for its own download before it will play.
- **Kiosk**: full screen, no tabs, no address bar.
- **Arrow keys move between titles** (`--enable-spatial-navigation`): Netflix's
  website was made for a mouse, and this lets the keyboard walk its rows. Enter
  opens; in the player, Space plays and pauses, ←/→ seek, F is full screen, Esc
  steps back.
- **Home to leave**: Home (or Ctrl+Q) closes NetflixHD — Netflix keeps Esc and
  Backspace for "back", so the way out is the key a TV remote calls Home. When
  it closes, [OMATVLauncher](https://github.com/FromChaosComesClarity/OMATVLauncher)
  comes back on its own, if it is installed. (A tiny bundled extension does the
  closing; a web page cannot close its own window.)
- **One window**: launching it again brings the open one to the front.
- **Hardware video decode** (VA-API) where the GPU has it.

## Know before you watch

- **720p is the ceiling.** Netflix limits every browser on Linux to 720p: Linux
  only gets software Widevine (L3), with no protected path to the display. That
  is Netflix's policy, not something an app can change — so "HD" here means
  720p. Higher needs a device Netflix certifies (a TV's own app, a streaming
  stick).
- **It is Netflix's website.** There is no public Netflix TV interface the way
  `youtube.com/tv` exists for YouTube; this is the site, made comfortable for a
  TV.
- **Why not the Android TV app** (through Waydroid): Netflix checks that the
  device is Google-certified and has hardware DRM before it will play, and an
  Android container on a PC is neither — it ends in an error code, or at best
  480p, in a much heavier stack.

## Install

```bash
git clone https://github.com/FromChaosComesClarity/NetflixHD
cd NetflixHD
./install.sh
```

That puts `netflixhd` in `~/.local/bin`, and NetflixHD in the system menu. In
OMATVLauncher, choose **Add app** and pick NetflixHD.

```bash
./install.sh --uninstall   # remove it, keep the login
./install.sh --purge       # remove it and the profile
```

Needs Chromium, Google Chrome or Brave, and Widevine having been used once in
it (playing anything DRM-protected is enough). Without that, the first launch
still works — it just waits for Chromium to fetch Widevine itself.

## License

GPL-3.0, like the rest of this account's TV projects.
