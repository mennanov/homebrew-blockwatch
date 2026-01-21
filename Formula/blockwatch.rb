class Blockwatch < Formula
  desc "Language agnostic linter that keeps your code and documentation in sync and valid"
  homepage "https://github.com/mennanov/blockwatch"
  version "0.2.21"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.21/blockwatch-aarch64-apple-darwin.tar.xz"
      sha256 "441819ad65514dfda08f68a0b7e6155408cd0dab85053f4420c66eb2697c3d58"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.21/blockwatch-x86_64-apple-darwin.tar.xz"
      sha256 "334ed7843640c6c6537e3c652c8a927c5519c9233c1caed1865f4a25aa1a6364"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.21/blockwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "77a20cb8f3243612d616072e81bfc343243d795871d89e27eaf30282907c0957"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.21/blockwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "77ced94eda29f10077b05d922c138d64307dabffffe1b3082d46d37bbc68fc13"
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
