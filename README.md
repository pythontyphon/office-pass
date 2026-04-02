# office-pass

A small macOS CLI that computes your office captive-portal password when the password increases by exactly +1 per local calendar day.

## Behavior

- `--init <number>` stores today as the baseline date with the provided password number.
- Each local day after midnight, the computed password increases by 1.
- Running with no flags prints only the password number (for copy-paste use).
- `--date <YYYY-MM-DD>` prints what the password is for a specific local date.

## Install (local build)

```bash
swift build -c release
cp .build/release/office-pass /usr/local/bin/office-pass
```

If your system uses Apple Silicon and `/opt/homebrew/bin` is preferred, copy there instead.

## Usage

Initialize with today\'s password:

```bash
office-pass --init 123456789
```

Get today\'s password:

```bash
office-pass
```

Show help:

```bash
office-pass --help
```

Get password for a specific date:

```bash
office-pass --date 2026-04-02
```

## Storage

Configuration is saved at:

- `~/Library/Application Support/office-pass/config.json`

Stored fields:

- `seed`: baseline password number provided at init time
- `initDay`: local start-of-day timestamp when init was run

## Error behavior

- If config is missing, command exits non-zero and asks you to run `office-pass --init <number>`.
- If config is corrupted, command exits non-zero and asks you to initialize again.
- If system time moves backward before `initDay`, output is clamped to the original seed (never decrements below seed).

## Homebrew distribution (v1: source tap)

This repo now includes:

- `Formula/office-pass.rb` as a source-build formula template.
- `scripts/release-homebrew-source.sh` to update formula URL and SHA256 for a new tag.

See `docs/homebrew-tap.md` for the source-tap rollout.

## Internal distribution fallback

- `scripts/install-internal.sh` installs a binary from your internal artifact URL with SHA256 verification.
- See `docs/internal-install.md` for setup and usage.

## Tests

```bash
swift test
```
