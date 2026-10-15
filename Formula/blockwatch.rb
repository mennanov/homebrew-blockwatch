class Blockwatch < Formula
  desc "Language agnostic linter that keeps your code and documentation in sync and valid"
  homepage "https://github.com/mennanov/blockwatch"
  version "0.11.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.11.3/blockwatch-aarch64-apple-darwin.tar.xz"
      sha256 "1749a8712cc803a024fe2a2b4842209ad149590a600bf94bece0d4e4f3c90e4d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.11.3/blockwatch-x86_64-apple-darwin.tar.xz"
      sha256 "dfb27216d7741f3b39ec64444d06e22d9cc2e7eff3bad001e046aaa0d2288ada"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.11.3/blockwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dc111d5a4d1f03dc2382e7c1a35595cb204839654f01dd979e18eccf348317ec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.11.3/blockwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2dcf7d449a53f6df1e84ff1fa9c956d07e43e2bcded55d5b9b6362fa9c6a0571"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "blockwatch"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "blockwatch"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "blockwatch"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "blockwatch"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
