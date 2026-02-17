class Blockwatch < Formula
  desc "Language agnostic linter that keeps your code and documentation in sync and valid"
  homepage "https://github.com/mennanov/blockwatch"
  version "0.2.23"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.23/blockwatch-aarch64-apple-darwin.tar.xz"
      sha256 "399e2b759f1c0c879f1cf6c781e98707e36850db83ec7a78f40fe7f34942fea4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.23/blockwatch-x86_64-apple-darwin.tar.xz"
      sha256 "07adefa3015ec5b49fd9f9e4e8611d3f8c9fdd4700287b7759cadc3e10716745"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.23/blockwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cf44b1903fda4f96764b74b645182ac47991db56b2d15aead00f77bd3a8b1f42"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.23/blockwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ec955a0f38a15b506fd7e141c2e94c6b823b63de0d90e68a3c306b97a6f27911"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "blockwatch" if OS.mac? && Hardware::CPU.arm?
    bin.install "blockwatch" if OS.mac? && Hardware::CPU.intel?
    bin.install "blockwatch" if OS.linux? && Hardware::CPU.arm?
    bin.install "blockwatch" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
