# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- README "Updating" section documenting how to pull updates for each install method
- CI: GitHub Actions workflow running `shfmt -d .` on PRs and pushes to `main`

## [0.1.0] - 2026-08-01

### Added

- `gpull`, `gprune`, `gbranches`, `grefresh` git aliases
- `bclean [--force]` — switch to the default branch and delete the one you were just on. Safe-deletes by default (refuses if unmerged); `--force` force-deletes instead, for branches git can't detect as merged (e.g. after a squash/rebase merge)
- `rpsync [--prefix <prefix>] [--safe]` — sync repos under `$ZSH_TOOLBOX_REPOS_DIR` (or the current directory if unset). `--prefix` limits the sync to `<prefix>-*` repos; `--safe` skips any repo that isn't cleanly on its default branch (extra local branches or uncommitted changes), and prints a summary of what was skipped
- `qclone <org> <repo> [--https|--ssh]` — clone a GitHub repo without typing the full URL. Protocol defaults to `$ZSH_TOOLBOX_CLONE_PROTOCOL`, overridable per-call
