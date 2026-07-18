class Blockwatch < Formula
  desc "Language agnostic linter that keeps your code and documentation in sync and valid"
  homepage "https://github.com/mennanov/blockwatch"
  version "0.3.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.3.8/blockwatch-aarch64-apple-darwin.tar.xz"
      sha256 "5354f017f43f4913ef4b01b0196450ae56638aa2e24b8e4ea434a2dfa1d0e28d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.3.8/blockwatch-x86_64-apple-darwin.tar.xz"
      sha256 "d0d48010096308d299b8672550942ec78e53c4d17cb287c4b88613ec32c00cc1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.3.8/blockwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ee7b52be578d7de118bf03b4276cbee2995ffdd603071b5150928304396ef8f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.3.8/blockwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "71022a6c9caab94e180b582f70178ecce280e8e6cfd300b581c2377642bb1fe3"
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
