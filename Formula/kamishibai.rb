class Kamishibai < Formula
  desc "Turn a list of words into an illustrated anki deck with native-speaker audio"
  homepage "https://github.com/anatoly-chichikov/kamishibai"

  url "https://github.com/anatoly-chichikov/kamishibai/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "c7d989e63a780e4478a6380647b413bd3c2ac57665ce1e9ae6914b332bc2a7a8"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/anatoly-chichikov/homebrew-tap/releases/download/kamishibai-1.13.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7792665582e3c117d80f18e513d9836286cbea81838c56d743cd928c1a69015"
    sha256 cellar: :any,                 arm64_linux:   "1ae13fc2c8b707592eb30a9785ca3a82ec0ec95aebc7e7f8e20f06cf63729658"
    sha256 cellar: :any,                 x86_64_linux:  "8c3df8f8474abe3638b785b64ffde3576fe5cada950c4b050dfdcad893e846ab"
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
    assert_equal "kamishibai 1.13.1", shell_output("#{bin}/kamishibai --version").strip
  end
end
