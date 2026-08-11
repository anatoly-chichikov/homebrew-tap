class Kamishibai < Formula
  desc "Turn a list of words into an illustrated anki deck with native-speaker audio"
  homepage "https://github.com/anatoly-chichikov/kamishibai"

  url "https://github.com/anatoly-chichikov/kamishibai/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "b0746f77002ebbee3ab17c008be4a614857ed5e4365434ed5e6ff05bcc6d85a6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/anatoly-chichikov/homebrew-tap/releases/download/kamishibai-1.7.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b862ba4483369d6adb1c54fcce067491f774c702cc0fd0870a3cf45d58f666e9"
    sha256 cellar: :any,                 arm64_linux:   "33b7df9a41c8c2ae8da4b37de46133d12e25aa770522033157bce6e9065ca383"
    sha256 cellar: :any,                 x86_64_linux:  "80fae1f07685d7d95c4ecc115ed878a235f97abaf11265face36216189cc1307"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  resource "mnn-prebuilt" do
    if OS.mac?
      url "https://github.com/zibo-chen/MNN-Prebuilds/releases/download/dev/mnn-dev-macos-universal.tar.gz"
      sha256 "8579086e8b959c6b7439cb55f3e3e4a97e918fc1f4fb6ae5089b6f6efe7aa4e7"
    elsif Hardware::CPU.arm?
      url "https://github.com/zibo-chen/MNN-Prebuilds/releases/download/dev/mnn-dev-linux-aarch64.tar.gz"
      sha256 "4b877aa72843c820453da7948c6c149a055c9ee7c2de99db10fa3901da49136f"
    else
      url "https://github.com/zibo-chen/MNN-Prebuilds/releases/download/dev/mnn-dev-linux-x86_64.tar.gz"
      sha256 "da127b395fa70f88cf0a397c13747f17870640d66d49d9176fb804b86a1b60b2"
    end
  end

  def install
    ENV["CARGO_HOME"] = buildpath/".cargo"
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm").to_s
    system "cargo", "fetch", "--locked"
    ocr_source = Pathname(Dir[buildpath/".cargo/registry/src/*/ocr-rs-2.2.2"].fetch(0))
    mkdir_p ocr_source/"3rd_party/prebuilt"
    resource("mnn-prebuilt").stage ocr_source/"3rd_party/prebuilt"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "kamishibai 1.7.2", shell_output("#{bin}/kamishibai --version").strip
  end
end
