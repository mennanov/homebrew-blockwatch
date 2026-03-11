class Blockwatch < Formula
  desc "Language agnostic linter that keeps your code and documentation in sync and valid"
  homepage "https://github.com/mennanov/blockwatch"
  version "0.2.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.25/blockwatch-aarch64-apple-darwin.tar.xz"
      sha256 "474b335cda5fcd5363cf1946efc408e086e71e1904709c5a63a2c6622bd50420"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.25/blockwatch-x86_64-apple-darwin.tar.xz"
      sha256 "92dc0ce02426342ec1a5968208690ce3bc0490363b7dbbe3e18c3160b1043e9e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.25/blockwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fca6892c640c3ff5e2bb051ee21c7aac5a3900c9f5f2dedef365cdc716e39a6d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.25/blockwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fd8f91a9572a80b2893861fc464c1fdf2d50a30c21bf1ab8e9934b76f07e1cb8"
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
