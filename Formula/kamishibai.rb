class Kamishibai < Formula
  desc "Turn a list of words into an illustrated anki deck with native-speaker audio"
  homepage "https://github.com/anatoly-chichikov/kamishibai"

  url "https://github.com/anatoly-chichikov/kamishibai/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "b26c1d76729e08b2b3e4e805616d90140b93542e23638503dac8057d69b4cf0b"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/anatoly-chichikov/homebrew-tap/releases/download/kamishibai-1.11.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61761ac149f39cf28a1b293bc770da80ce959241be25c28d00192687a9f4acb0"
    sha256 cellar: :any,                 arm64_linux:   "586c7a846fbc9590cad09feb58fc7ec454a6dfcd65930d3435dd12f0ec06712e"
    sha256 cellar: :any,                 x86_64_linux:  "3e4959e3ad1e1449df083ad8f411d0092f4b31070de254180d97072d5eda7db8"
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
    assert_equal "kamishibai 1.11.1", shell_output("#{bin}/kamishibai --version").strip
  end
end
