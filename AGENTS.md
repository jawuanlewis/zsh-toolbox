# Project Context - `zsh-toolbox`

A public, personal-portfolio zsh plugin: git workflow aliases/functions, designed to be usable by any dev, not just the author. Every decision below stems from that "no assumptions about the user's setup" goal — keep it that way when adding to this repo.

## Structure

- `aliases/<domain>.zsh` and `functions/<domain>.zsh` — split by domain (currently just `git`), not by alias-vs-function.
- `zsh-toolbox.plugin.zsh` — single entry point; sources `aliases/*.zsh` then `functions/*.zsh`. Compatible with zinit/antidote/oh-my-zsh/manual `source`.
- `functions/_shared.zsh` — internal helpers (currently `_zsh_toolbox_default_branch`). Leading underscore is deliberate: it sorts before other filenames alphabetically, so it loads first.

## Conventions

- **Naming**: public aliases/functions in a domain share a short prefix to avoid clobbering the user's other tools (`g` for git — `gpull`, `gbranches`, etc.). Internal helpers are prefixed `_zsh_toolbox_`. Follow this pattern for any new domain (e.g. `d` for docker).
- **Configuration**: anything that varies per user/machine is an env var namespaced `ZSH_TOOLBOX_*` (e.g. `ZSH_TOOLBOX_CLONE_PROTOCOL`, `ZSH_TOOLBOX_REPOS_DIR`), always with a sane fallback — never require configuration just to get default behavior.
- **Safety default**: anything that could discard local work defaults to the safe/conservative behavior, with an explicit opt-in flag for the destructive alternative (see `bclean` — safe-delete by default, `--force` to override; `rpsync --safe` skips repos with uncommitted changes or unexpected branches). Keep this asymmetry when adding new destructive operations.
- **Formatting**: `shfmt` (not `shellcheck` — it doesn't understand zsh syntax and false-positives on things like extended glob qualifiers). `.zsh` extension auto-selects zsh dialect; indent width comes from `.editorconfig`. Run `shfmt -w .` before committing; CI enforces this via `shfmt -d .` on PRs and pushes to `main` (see `.github/workflows/format-check.yml`).

## Known gotcha

`git branch -d` can't detect a branch as "merged" after a squash or rebase merge (the target branch gets a new commit SHA with no ancestry link back). This is why `bclean --force` exists — it's not a workaround for a bug, it's the intended escape hatch for that exact git limitation.

## Testing

No automated test suite. Changes are verified manually before every commit:
1. `zsh -n <file>` per changed file (syntax)
2. `shfmt -d .` (formatting, should be empty)
3. Functional smoke test against throwaway git repos in a temp dir (stub `grefresh`/`git` where useful to avoid real network calls)

## Release process

- `CHANGELOG.md` follows [Keep a Changelog](https://keepachangelog.com) + [SemVer](https://semver.org). Add entries under `## [Unreleased]` as you go.
- Still pre-1.0 (`0.x`) — breaking changes to function signatures are fine without a major bump, but still call them out clearly in the changelog.
- Cutting a release: rename `Unreleased` → `## [x.y.z] - YYYY-MM-DD`, add a fresh empty `Unreleased` above it, as part of the PR that ships it. After merge, tag `vX.Y.Z` on `main`.
- Workflow is branch + PR — `main` has branch protection enabled, so direct pushes are rejected.

## Repo facts

- GitHub: `jawuanlewis/zsh-toolbox`, public, MIT licensed.
- CI: GitHub Actions `format-check` workflow runs `shfmt -d .` on PRs/pushes to `main`. shfmt is installed from a pinned release binary (v3.13.1) rather than a marketplace action, since none of the common ones are officially maintained by mvdan/sh.
