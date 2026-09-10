# Stvena Homebrew tap

Homebrew formula for [Stvena](https://github.com/nccapo/stvena) — a live review
workspace that runs beside Codex and Claude Code in the same terminal.

## Install

```sh
brew install nccapo/stvena/stvena
```

That one command taps this repository, trusts only the `stvena` formula, and
installs the binary. Homebrew 6.0 requires non-official taps to be trusted
before their Ruby is evaluated; installing a fully qualified name grants trust
to that single formula.

To tap first and install by short name:

```sh
brew tap nccapo/stvena
brew trust --formula nccapo/stvena/stvena
brew install stvena
```

Upgrade and uninstall as usual:

```sh
brew upgrade stvena
brew uninstall stvena
```

## What you get

The formula installs the prebuilt `stvena` binary published on the
[stvena releases page](https://github.com/nccapo/stvena/releases), verified
against the SHA-256 checksums from that release.

| Platform | Architectures |
| --- | --- |
| macOS | Apple Silicon (`arm64`), Intel (`amd64`) |
| Linux | `arm64`, `amd64` |

Native Windows is not supported. Stvena needs Git, an interactive terminal, and
the agent CLI you intend to run (Codex or Claude Code), installed and
authenticated separately.

This is a formula rather than a cask because casks are macOS-only; Stvena
supports Linux too, and Homebrew does not quarantine formula downloads.

## Updating the formula

`scripts/update-formula.sh` rewrites the version, download URLs, and checksums
from a release's published `checksums.txt`:

```sh
./scripts/update-formula.sh          # latest stable release
./scripts/update-formula.sh v0.1.4   # a specific tag
```

The **Update formula** workflow runs it automatically when `nccapo/stvena`
finishes a release (via `repository_dispatch`), on manual dispatch, and every
six hours as a fallback. Prereleases are skipped — `scripts/update-formula.sh`
with no argument resolves the latest non-prerelease tag, so a tag like
`v0.2.0-preview.1` only lands here if it is passed explicitly.

Every change is checked by the **Tests** workflow, which installs the formula on
macOS and Linux and runs `brew test` and `brew audit`.

## Repository naming

`brew tap nccapo/stvena` resolves to `github.com/nccapo/homebrew-stvena`. The
`homebrew-` prefix is required for the short form to work.

## License

MIT, matching [nccapo/stvena](https://github.com/nccapo/stvena).
