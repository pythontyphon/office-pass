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
