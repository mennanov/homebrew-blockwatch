class Blockwatch < Formula
  desc "Language agnostic linter that keeps your code and documentation in sync and valid"
  homepage "https://github.com/mennanov/blockwatch"
  version "0.2.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.10/blockwatch-aarch64-apple-darwin.tar.xz"
      sha256 "8488ad5c928cf61cfc6ba9a205188b528288654fcae311ea4ef4137b89b8aeff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.10/blockwatch-x86_64-apple-darwin.tar.xz"
      sha256 "fccf6a8c666110107cd46979606faa0ccd2739628136deb1f3960aac4e2f8ea0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.10/blockwatch-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c63628a346e53243ebed5f31d439aecd500749e5cc8d39bd420ee86f0182e324"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mennanov/blockwatch/releases/download/v0.2.10/blockwatch-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "061400eb1b135c3e8fe4de74816ec2334bf260337ae92f4b8a5c4490b084e2b0"
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
