class Kamishibai < Formula
  desc "Turn a list of words into an illustrated anki deck with native-speaker audio"
  homepage "https://github.com/anatoly-chichikov/kamishibai"

  url "https://github.com/anatoly-chichikov/kamishibai/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "b5f0c1b708d4bd6ca553b3abd0b0fbd4b5f1331b1f04ca653f3037a2251a8273"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/anatoly-chichikov/homebrew-tap/releases/download/kamishibai-1.2.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d942745788658757ae6d62fcb2268081ab80a5d923072e2a1f71894be3082897"
    sha256 cellar: :any,                 arm64_linux:   "cfb69395cfd41bbf8bc499cc7327433fcfa077fbcc48f6e5ca296e3e8ee5648f"
    sha256 cellar: :any,                 x86_64_linux:  "e06d93344989a193ab47964254379d797527ca590542cab062c3142c49696380"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  resource "mnn-prebuilt" do
    if OS.mac?
      url "https://github.com/zibo-chen/MNN-Prebuilds/releases/download/dev/mnn-dev-macos-universal.tar.gz"
      sha256 "e2a5e38b3ad6e5212208fbed66f63f0487fee6d01fab973a28370cb18ebd2233"
    elsif Hardware::CPU.arm?
      url "https://github.com/zibo-chen/MNN-Prebuilds/releases/download/dev/mnn-dev-linux-aarch64.tar.gz"
      sha256 "51eea637937a9b4c6bf3aebd112837d087a2cf0a69b08ef7d13fb149eea004a2"
    else
      url "https://github.com/zibo-chen/MNN-Prebuilds/releases/download/dev/mnn-dev-linux-x86_64.tar.gz"
      sha256 "da7b7d2c7c249c8460d7e6a66b504a3125bdcaa3a54218f8c9ec0fa8549e37eb"
    end
  end

  def install
    ENV["CARGO_HOME"] = buildpath/".cargo"
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s
    system "cargo", "fetch", "--locked"
    ocr_source = Pathname(Dir[buildpath/".cargo/registry/src/*/ocr-rs-2.2.2"].fetch(0))
    mkdir_p ocr_source/"3rd_party/prebuilt"
    resource("mnn-prebuilt").stage ocr_source/"3rd_party/prebuilt"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "kamishibai 1.2.0", shell_output("#{bin}/kamishibai --version").strip
  end
end
