class Blockwatch < Formula
  desc "Language agnostic linter that keeps your code and documentation in sync and valid"
  homepage "https://github.com/mennanov/blockwatch"
  version "0.10.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.10.2/blockwatch-aarch64-apple-darwin.tar.xz"
      sha256 "72db8f3074e29096f94795ad27c520ff5a57c0dd3e28b456fa1466549c9e4a2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.10.2/blockwatch-x86_64-apple-darwin.tar.xz"
      sha256 "8a7fb06932742c5c329eabbcc49fb273d49476002d4e31ab5e054a0e92d01d26"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.10.2/blockwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc84e5738c9358e8e287b6c9a6dfecb19b80a6a5920661f94789ba5262bc957d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.10.2/blockwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7a9ed28357c1416e5f314c1813590cc2a2743cec594335fd2cc437dd9be62a01"
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
