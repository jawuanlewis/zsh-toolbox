# zsh-toolbox

A small, growing collection of zsh aliases and functions for keeping a git-heavy workflow fast and tidy — quick clones, branch cleanup, and multi-repo syncing.

## What's included

### Aliases (`aliases/git.zsh`)

| Name | Description |
| --- | --- |
| `gpull` | Pull the current repo's default branch (`main`/`master`/etc.) from origin |
| `gprune` | Prune stale remote-tracking branches (`git fetch --prune`) |
| `gbranches` | List local branches with tracking/ahead-behind info (`git branch -vv`) |
| `grefresh` | Runs `gpull`, `gprune`, and `gbranches` in sequence |

### Functions (`functions/git.zsh`, `functions/utils.zsh`)

| Name | Description |
| --- | --- |
| `bclean` | Switch to the default branch and delete the branch you were just on |
| `rpsync <prefix> [--safe]` | Sync all repos under `$HOME/code` matching `<prefix>-*`. With `--safe`, only syncs repos on their default branch with no other local branches, and prints a summary of anything skipped |
| `qclone <org> <repo>` | Clone `git@github.com:<org>/<repo>.git` without typing the full URL |

All functions assume repos live under `$HOME/code` and that you have SSH access configured for GitHub.

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

## License

MIT — see [LICENSE](LICENSE).
