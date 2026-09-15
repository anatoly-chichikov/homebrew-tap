class Kamishibai < Formula
  desc "Turn a list of words into an illustrated anki deck with native-speaker audio"
  homepage "https://github.com/anatoly-chichikov/kamishibai"

  url "https://github.com/anatoly-chichikov/kamishibai/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "146c4f65dc47b3ea61d779c081768d8987fcf43a59da35da21a50fee032a1b1c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/anatoly-chichikov/homebrew-tap/releases/download/kamishibai-1.12.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3e128fb518aed2fe3e5164c270c2c2ed9cfa0dc8cf0d665c0bb143ce3eebb06"
    sha256 cellar: :any,                 arm64_linux:   "e9255ff72f6b570edefb50c2d58cd62f60266248597d8baf3bbb2049b7379a04"
    sha256 cellar: :any,                 x86_64_linux:  "d82d19e158df0588e165f2ccbf7e4edd4b5e72e8ac9ca2cee7086c255568a147"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  resource "mnn-prebuilt" do
    if OS.mac?
      url "https://github.com/zibo-chen/MNN-Prebuilds/releases/download/dev/mnn-dev-macos-universal.tar.gz"
      sha256 "61e0f340b062cae44d0995610c90ad46b9609839f02854b61f4164ea91698bbd"
    elsif Hardware::CPU.arm?
      url "https://github.com/zibo-chen/MNN-Prebuilds/releases/download/dev/mnn-dev-linux-aarch64.tar.gz"
      sha256 "1ce0b2ed372fbb1db49273d8b835ae5338a0696002f3a6632ec8a14ff52bd50e"
    else
      url "https://github.com/zibo-chen/MNN-Prebuilds/releases/download/dev/mnn-dev-linux-x86_64.tar.gz"
      sha256 "0692b88f2a4caa4c1a3793bf93c84317e1f999e515102c91ddc278aa18b2a4df"
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
    assert_equal "kamishibai 1.12.0", shell_output("#{bin}/kamishibai --version").strip
  end
end
