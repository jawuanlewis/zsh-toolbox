# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- Initial release: `gpull`, `gprune`, `gbranches`, `grefresh` aliases
- `bclean`, `rpsync`, `qclone` functions

### Changed

- `qclone` now supports HTTPS as well as SSH, via the `$ZSH_TOOLBOX_CLONE_PROTOCOL` env var or a `--https`/`--ssh` flag per call. Defaults to `ssh`, matching prior behavior.
