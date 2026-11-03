class Blockwatch < Formula
  desc "Language agnostic linter that keeps your code and documentation in sync and valid"
  homepage "https://github.com/mennanov/blockwatch"
  version "0.16.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.16.5/blockwatch-aarch64-apple-darwin.tar.xz"
      sha256 "88f0abe2c9db991d9b93d7e381a5413c6559567c58eb7ac0ef995fb91c56ccc2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.16.5/blockwatch-x86_64-apple-darwin.tar.xz"
      sha256 "8044da6bcd5e997b34498f38b6ccfc28093a8f565c81ce3074f21463bb8bf7cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.16.5/blockwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2e92354411fe77b739371e29a15b69f22846f76533a50e1281e3f7fcd40df412"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.16.5/blockwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6a86b79c2b3e49582bd13994355930b65db57780c35408352b82e0eceea2f53f"
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
