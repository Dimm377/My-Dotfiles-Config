# Arch + Caelestia dotfiles

Personal configuration preserved from the working Arch Linux, Caelestia,
Hyprland, Fish, Kitty/Foot, and LazyVim setup. GNU Stow manages individual
configuration files. Caelestia continues to own its upstream files and generated
colors. There is no additional theme engine or installation framework.

## Packages

| Stow package | Contents |
| --- | --- |
| `starship` | Native Caelestia Starship template |
| `fish` | Interactive configuration, greeting, SIGUSR1 repaint handler |
| `fastfetch` | Custom system-information display |
| `caelestia` | CLI/theme hook, shell preferences, user Fish extension point |
| `hypr` | `hypr-user.lua` and `hypr-vars.lua` in the Caelestia override directory |
| `kitty` | Kitty configuration |
| `foot` | Foot configuration |
| `kitty-border` | Existing Kitty border systemd user path/service units |
| `scripts` | Dropdown terminal, game-mode, panel toggle, Kitty border helpers |
| `nvim` | LazyVim configuration and plugin lockfile, without nested Git metadata |

Use `--no-folding` to create file symlinks instead of replacing whole config
directories. This leaves upstream files and application-written state outside
this repository.

## System packages versus user dotfiles

This repository contains text configuration and custom scripts, not applications,
fonts, plugin binaries, credentials, or system services installed by packages.
Install the software separately before restoring the dotfiles.

The migration ran GNU Stow 2.4.1 from the official Arch package extracted in
`/tmp`, with its SHA256 checked against the local Arch package database. System-wide
Stow installation still requires `sudo pacman -S --needed stow`; no package
binary or temporary migration tool is stored in this repository.

Base packages used by these configurations:

```sh
sudo pacman -S --needed base-devel git stow fish starship fastfetch kitty foot \
  neovim eza zoxide direnv bat ripgrep jq glow file poppler procps-ng \
  ttf-cascadia-code-nerd libnotify power-profiles-daemon
```

Install Caelestia CLI/shell, Hyprland, their dependencies and session integration
using the supported Caelestia installation process. With the configured AUR helper
available, this setup uses `caelestia-cli-git` and `caelestia-shell-git`; then run
`caelestia install` and include the Neovim component. Let Caelestia deploy its
upstream files before applying this repository.

Caelestia provenance at migration:

- Dots repository: `https://github.com/caelestia-dots/caelestia.git`
- Applied dots revision: `1ee7a98522b86582b924c5b643b534c13be64180`
- CLI package: `caelestia-cli-git 1.1.2.r38.g167368f-1`
- Shell package: `caelestia-shell-git 2.4.0.r22.g750e67d-1`
- Hyprland: `0.56.2-2` (this configuration uses its Lua interface)
- Fish: `4.8.1-1`; Starship: `1.26.0-1`; procps-ng: `4.0.7-1`

These versions document the working baseline, not a complete frozen OS image.
Review upstream migration notes before upgrading across incompatible versions.
The repaint hook requires `pkill --require-handler` support.

Additional workflow dependencies include `paru`, `lazygit`, `zen-browser`, Spotify,
and the Hyprexpo Hyprland plugin installed through `hyprpm`. Install only the
applications you use; their data/accounts are not included. Game mode needs the
service providing `powerprofilesctl`. Node.js, Python, Rust and Go are development
tools used by the editor and contextual prompt. Bun is optional. Neovim restores
its plugins from `lazy-lock.json`; Mason and Treesitter install their own tools
and parsers separately.

## Restore on fresh Arch

1. Install the dependencies and Caelestia as described above. Launch its Hyprland
   session and select a wallpaper so that its dynamic scheme exists.
2. Clone this repository to `~/dotfiles` from your chosen backup/remote. No remote
   is configured by the initial migration.
3. Review the machine-specific values below. Back up any existing destination
   files outside the repository before replacing them. Do not overwrite a
   working installation with an unreviewed bulk command.
4. Work one package at a time from `~/dotfiles`. For example:

   ```sh
   stow --no-folding --simulate --verbose --target="$HOME" fish
   ```

   If Stow reports conflicts, inspect those exact paths. Move the conflicting
   originals to a timestamped backup outside `~/dotfiles`, preserving relative
   paths and symlinks. Repeat the dry run, then apply:

   ```sh
   stow --no-folding --verbose --target="$HOME" fish
   ```

   Repeat for `starship fish fastfetch caelestia hypr kitty foot kitty-border
   scripts nvim`, validating each package. Do not use `--adopt` blindly on a fresh
   installation: it would replace repository files with the destination files.
   The original migration used adoption only after byte-for-byte verification
   and backups.
5. Restore the generated Starship link as described below.
6. Enable the existing Kitty border watcher and refresh user unit definitions:

   ```sh
   systemctl --user daemon-reload
   systemctl --user enable --now kitty-caelestia-border.path
   ```

7. Open an interactive Fish terminal. For a Fish session already running when
   these files were installed, load the repaint handler once:

   ```fish
   source ~/.config/fish/conf.d/caelestia-repaint.fish
   ```

No global Git identity is supplied. Set your author identity separately,
repository-locally if preferred.

## Dynamic Starship and live repainting

Editable source:

```text
~/.config/caelestia/templates/starship.toml
```

Caelestia renders native `{{ token.hex }}` substitutions into:

```text
~/.local/state/caelestia/theme/starship.toml
```

The normal Starship path is a separate, non-Stow link to that generated file:

```text
~/.config/starship.toml -> ../.local/state/caelestia/theme/starship.toml
```

On a fresh installation, first move any existing `~/.config/starship.toml` into
your backup directory. Change/select a wallpaper using Caelestia to render the
installed template, then create the link (without force-overwriting anything):

```sh
ln -s ../.local/state/caelestia/theme/starship.toml ~/.config/starship.toml
```

The generated colors are deliberately not committed. Edit the source template,
not its generated output. Reapply a wallpaper after changing the template.

Refresh flow:

```text
Wallpaper/scheme change
  -> Caelestia applies colors and renders user templates
  -> theme.postHook sends SIGUSR1 to this user's Fish processes with a handler
  -> interactive Fish runs commandline -f repaint
  -> Starship reads the new generated configuration
```

The hook does not reinitialize Starship, parse colors on every prompt, poll, or
run a permanent daemon. It preserves the current Arch/home pill, contextual Git
and runtimes, clock, and second-line prompt character.

The separate Kitty border integration is an existing systemd `.path` unit and
one-shot script, not part of Starship rendering. It consumes Caelestia's scheme
and Kitty's configured remote-control socket. Its enablement symlink is generated
by systemd and is not tracked.

## Machine-specific settings preserved unchanged

- Hyprland overrides specify `eDP-1`, `1920x1080@144`, scale 1 and position `0x0`.
- Both terminals use CaskaydiaCove Nerd Font at size 14.
- Hyprexpo needs a compatible installed plugin; the override reloads `hyprpm`
  plugins at Hyprland startup.
- These dotfiles use conventional `~/.config` and `~/.local/state` locations.
  Review paths if using a non-default XDG layout.
- Wallpapers are not included. Restore your own wallpaper collection separately.

## Validation

- Confirm Stow's dry run reports no conflicts and symlinks resolve into this repo.
- Run `fish -n ~/.config/fish/config.fish` and open an interactive Fish session.
- Run `fastfetch` and inspect the current layout.
- Run `starship prompt` at HOME and inside Git and language projects.
- Change wallpaper A -> B -> A with two Fish terminals idle; both should repaint.
- Check Kitty and Foot startup, font selection, keybindings and transparency.
- Check `systemctl --user status kitty-caelestia-border.path`.
- Check `hyprctl configerrors`, the dropdown/panel/game-mode shortcuts and Hyprexpo.
- Open Neovim and use `:Lazy restore` to restore the committed plugin lockfile.

## Updates and exclusions

Caelestia retains ownership of the main `~/.config/hypr` tree, default application
files, and its two deployed Neovim files (`colors/caelestia.lua` and
`lua/plugins/caelestia.lua`). Those are intentionally absent here. User overrides
are stored only at the existing Caelestia extension points.

Caelestia updates may redeploy Fish, Foot, Fastfetch or the Starship link. Back up
and review conflicts; verify Stow links and the generated Starship link after an
update. Do not copy new generated palettes into Git or automatically adopt changed
upstream files over your customized copies.

Also excluded: Fish universal variables/history, caches, browser/session data,
secrets, credentials, installer binaries, Neovim's old `.git` directory, plugin
installations, unused Fastfetch art, empty monitor JSON, old backups, systemd
installation symlinks, and the Caelestia checkout/deployment database. No tmux or
Git configuration was invented. Neovim's Apache license is retained with its copied
configuration.

## Rollback

The original migration backup is outside the repository under:

```text
~/.local/share/dotfiles-backups/20260905-192748/
```

It contains `files/` preserving original paths and a migration manifest with hashes.
For one package, dry-run its removal first, then unstow it:

```sh
cd ~/dotfiles
stow --no-folding --simulate --verbose --delete --target="$HOME" fish
stow --no-folding --verbose --delete --target="$HOME" fish
```

Restore that package's original files from the backup with permissions preserved,
one path at a time. Do not restore over an unexpected new file; inspect it first.
The Starship generated-output link was not migrated and needs no rollback.
Neovim's pre-existing `.git` metadata was left in place. Keep backups until the
restored setup has been verified; they are not part of Git.
