# Zsh Toolbox

A small, growing collection of zsh aliases and functions for keeping a git-heavy workflow fast and tidy — quick clones, branch cleanup, and multi-repo syncing.

## What's included

### Aliases (`aliases/git.zsh`)

| Name        | Description                                                               |
| ----------- | ------------------------------------------------------------------------- |
| `gpull`     | Pull the current repo's default branch (`main`/`master`/etc.) from origin |
| `gprune`    | Prune stale remote-tracking branches (`git fetch --prune`)                |
| `gbranches` | List local branches with tracking/ahead-behind info (`git branch -vv`)    |
| `grefresh`  | Runs `gpull`, `gprune`, and `gbranches` in sequence                       |

### Functions (`functions/git.zsh`, `functions/utils.zsh`)

| Name                                   | Description                                                                                                                                                                                                                                                                                                                              |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `bclean [--force]`                     | Switch to the default branch and delete the branch you were just on. Uses a safe delete by default (refuses if unmerged); `--force` force-deletes instead — useful after a squash/rebase merge, which git can't detect as merged                                                                                                         |
| `rpsync [--prefix <prefix>] [--safe]`  | Sync repos under `$ZSH_TOOLBOX_REPOS_DIR` (or the current directory, see [Configuration](#configuration)) — everything by default, or only `<prefix>-*` repos with `--prefix`. With `--safe`, only syncs repos on their default branch with no other local branches and no uncommitted changes, and prints a summary of anything skipped |
| `qclone <org> <repo> [--https\|--ssh]` | Clone a GitHub repo without typing the full URL. Protocol defaults to `$ZSH_TOOLBOX_CLONE_PROTOCOL` (see [Configuration](#configuration)), overridable per-call                                                                                                                                                                          |

## Configuration

| Variable                     | Default           | Description                                                                                                                                                                                                             |
| ---------------------------- | ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `ZSH_TOOLBOX_CLONE_PROTOCOL` | `ssh`             | Protocol `qclone` uses when unset. Set to `https` in your `.zshrc` if you prefer HTTPS (e.g. on a machine without an SSH key configured for GitHub), or override per-call with `qclone <org> <repo> --https` / `--ssh`. |
| `ZSH_TOOLBOX_REPOS_DIR`      | current directory | Directory `rpsync` scans for repos when unset. Set it in your `.zshrc` to always point at your repos folder (e.g. `~/code`) regardless of where you run `rpsync` from.                                                  |

## Installation

### Option 1: Plugin manager (recommended)

**[zinit](https://github.com/zdharma-continuum/zinit)**

```zsh
zinit load jawuanlewis/zsh-toolbox
```

**[antidote](https://github.com/mattmc3/antidote)**

```zsh
antidote bundle jawuanlewis/zsh-toolbox
```

**[oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)** — clone into your custom plugins directory and enable it:

```bash
git clone https://github.com/jawuanlewis/zsh-toolbox.git \
  "${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-toolbox"
```

Then add `zsh-toolbox` to the `plugins=(...)` list in your `.zshrc`.

### Option 2: Manual clone + source

```bash
git clone https://github.com/jawuanlewis/zsh-toolbox.git ~/.zsh-toolbox
```

Add to your `.zshrc`:

```zsh
source ~/.zsh-toolbox/zsh-toolbox.plugin.zsh
```

### Option 3: Copy-paste

Everything is split into small, self-contained files under `aliases/` and `functions/` — grab only the ones you want and drop them into your own dotfiles. Functions in `functions/git.zsh` depend on the `_zsh_toolbox_default_branch` helper in `functions/_shared.zsh`, so bring that along too if you cherry-pick.

## Naming convention

Aliases and functions in a given domain share a short prefix to avoid clobbering other tools you may have installed (e.g. `g` for git — `gpull`, `gprune`, `gbranches`, `grefresh`). New categories added later (docker, npm, etc.) should follow the same pattern.

## Development

Code is formatted with [`shfmt`](https://github.com/mvdan/sh) (it understands zsh syntax, not just bash/POSIX):

```bash
brew install shfmt
shfmt -d .   # preview formatting changes
shfmt -w .   # apply them
```

Indent style (2 spaces) is set in [`.editorconfig`](.editorconfig), which `shfmt` reads automatically.

## License

MIT — see [LICENSE](LICENSE).
