class Kamishibai < Formula
  desc "Turn a list of words into an illustrated anki deck with native-speaker audio"
  homepage "https://github.com/anatoly-chichikov/kamishibai"

  url "https://github.com/anatoly-chichikov/kamishibai/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "471263449c7704ebe5bf23ef3b121da0b821b215d1b16ece42c6ebd731b57746"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/anatoly-chichikov/homebrew-tap/releases/download/kamishibai-1.8.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fd49595454d67d0c0176c206384eb2962225e8277e87a7c5fb84c5dce978794"
    sha256 cellar: :any,                 arm64_linux:   "a8e0839a0ba891331c10f1361aed4d0b05ca849a7d21df203dd1e44e319def31"
    sha256 cellar: :any,                 x86_64_linux:  "2db88a0ed77a7463fe9bb40ad479c79efaa39e92a4e68c002c9f58cffa9c0eb3"
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
    ocr_source = Pathname(Dir[buildpath/".cargo/registry/src/*/ocr-rs-2.4.1"].fetch(0))
    mkdir_p ocr_source/"3rd_party/prebuilt"
    resource("mnn-prebuilt").stage ocr_source/"3rd_party/prebuilt"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "kamishibai 1.8.1", shell_output("#{bin}/kamishibai --version").strip
  end
end
