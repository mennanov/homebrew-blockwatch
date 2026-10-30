class Blockwatch < Formula
  desc "Language agnostic linter that keeps your code and documentation in sync and valid"
  homepage "https://github.com/mennanov/blockwatch"
  version "0.16.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.16.2/blockwatch-aarch64-apple-darwin.tar.xz"
      sha256 "b4b3a58882894fe3a3d9eb131a3f53bd3003b7969799b3c43b52e47f75bac0e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.16.2/blockwatch-x86_64-apple-darwin.tar.xz"
      sha256 "665de916e7f49e6b0c9f5f4cedad4ca0ba411b885b71e0048501c0eb2ea29b91"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.16.2/blockwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "29741643dec5c0243557d4ee574385c43b63b48fc117a2abd47511de17beeae3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.16.2/blockwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab6fcbd163114344fba2cf5d40b1ab2209bb4b55ae961b5ca8e63ab415b78d82"
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
