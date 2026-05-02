class OfficePass < Formula
  desc "Daily incrementing office password helper"
  homepage "https://github.com/pythontyphon/office-pass"
  url "https://github.com/pythontyphon/office-pass/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "562d85178f14f80b31cf51e7a80a7331834a6909e5bf5d500de876b09ef466ca"
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
