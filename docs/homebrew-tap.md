# Homebrew Source Tap Plan

This is the practical v1 distribution path for `office-pass`.

## 1) Create a tap repository

Example: `your-org/homebrew-tools`

Inside that repo, add formula file:

- `Formula/office-pass.rb`

## 2) Formula source

This repository already includes a ready template at:

- `Formula/office-pass.rb`

Formula content:

```ruby
class OfficePass < Formula
  desc "Daily incrementing office password helper"
  homepage "https://github.com/your-org/office-pass-cli"
  url "https://github.com/your-org/office-pass-cli/archive/refs/tags/v0.1.0.tar.gz"
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
brew tap your-org/tools https://github.com/your-org/homebrew-tools
brew install office-pass
```

or with full formula naming:

```bash
brew install your-org/tools/office-pass
```

## 4) Version bump flow

1. Tag release in app repo, for example `v0.1.1`.
2. Update formula URL and SHA256 automatically:

```bash
OFFICE_PASS_REPO=your-org/office-pass-cli ./scripts/release-homebrew-source.sh v0.1.1
```

or manually compute tarball SHA256:

```bash
curl -L -o office-pass.tar.gz https://github.com/your-org/office-pass-cli/archive/refs/tags/v0.1.1.tar.gz
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
