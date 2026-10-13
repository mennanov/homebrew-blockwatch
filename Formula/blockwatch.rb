class Blockwatch < Formula
  desc "Language agnostic linter that keeps your code and documentation in sync and valid"
  homepage "https://github.com/mennanov/blockwatch"
  version "0.10.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.10.4/blockwatch-aarch64-apple-darwin.tar.xz"
      sha256 "e0c6739d09e2d8cc9f32e1940f0b2933925e0047c7f0c20ec87d8209db866d4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.10.4/blockwatch-x86_64-apple-darwin.tar.xz"
      sha256 "45db312f8997ed315ebd0e82bbef9a47e03dbc1a5fc6ff75fe77fee8558a9af9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.10.4/blockwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4f1938b32c3b32fe9d14bd6e3206a7c9d229df1d882242f750953349940e52e8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.10.4/blockwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa855d13022d5625ab2afaec87db86c1e72d3f404b406034411567819c7b4687"
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
