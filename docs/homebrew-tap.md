# Homebrew Source Tap Plan

This is the practical v1 distribution path for `office-pass`.

## 1) Create a tap repository

Example: `pythontyphon/homebrew-tools`

Inside that repo, add formula file:

- `Formula/office-pass.rb`

## 2) Formula source

This repository already includes a ready template at:

- `Formula/office-pass.rb`

Formula content:

```ruby
class OfficePass < Formula
  desc "Daily incrementing office password helper"
  homepage "https://github.com/pythontyphon/office-pass"
  url "https://github.com/pythontyphon/office-pass/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_TARBALL_SHA256"
  license "MIT"

  depends_on xcode: ["15.0", :build]

  def install
    system "swift", "build", "-c", "release"
    bin.install ".build/release/office-pass"
  end

  test do
    output = shell_output("#{bin}/office-pass --help")
    assert_match "office-pass", output
  end
end
```

## 3) User install command

```bash
brew tap pythontyphon/tools https://github.com/pythontyphon/homebrew-tools
brew install office-pass
```

or with full formula naming:

```bash
brew install pythontyphon/tools/office-pass
```

## 4) Version bump flow

1. Tag release in app repo, for example `v0.1.1`.
2. Update formula URL and SHA256 automatically:

```bash
OFFICE_PASS_REPO=pythontyphon/office-pass ./scripts/release-homebrew-source.sh v0.1.1
```

or manually compute tarball SHA256:

```bash
curl -L -o office-pass.tar.gz https://github.com/pythontyphon/office-pass/archive/refs/tags/v0.1.1.tar.gz
shasum -a 256 office-pass.tar.gz
```

3. Update `url` and `sha256` in formula.
4. Commit formula update in tap repo.
5. Users run:

```bash
brew update && brew upgrade office-pass
```

## Fallback if Homebrew is blocked

Use the internal installer documented in `docs/internal-install.md` and `scripts/install-internal.sh`.
