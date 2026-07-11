class Kamishibai < Formula
  desc "Turn a list of words into an illustrated anki deck with native-speaker audio"
  homepage "https://github.com/anatoly-chichikov/kamishibai"

  url "https://github.com/anatoly-chichikov/kamishibai/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "5fb30c500133d89e0b997489743796c900d721fd680509ced2706c563d1f43be"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/anatoly-chichikov/homebrew-tap/releases/download/kamishibai-1.4.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0a2b74af6e1e254ba05bf1a56e6de1eb9a482fa20529cd45cdf7a28d6725f54"
    sha256 cellar: :any,                 arm64_linux:   "4e45d7692fe7e097f3d67216f9d1625ea2a374a8470f2e5e9e865a0145dc44ee"
    sha256 cellar: :any,                 x86_64_linux:  "03a27f2e20b025f06d60c1798579e9bc0c79e0ab528572d73a0dd11911630523"
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
    assert_equal "kamishibai 1.4.2", shell_output("#{bin}/kamishibai --version").strip
  end
end
