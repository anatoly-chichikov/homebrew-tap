class Kamishibai < Formula
  desc "Turn a list of words into an illustrated anki deck with native-speaker audio"
  homepage "https://github.com/anatoly-chichikov/kamishibai"

  url "https://github.com/anatoly-chichikov/kamishibai/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "2d11ba44d43d8a0475bf65011a256193cd37f415e57da153317814ac4ecac215"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/anatoly-chichikov/homebrew-tap/releases/download/kamishibai-1.5.1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "415807d667f7e1507a2490fa87d937316f8883818f419eb604287a730f63f5ab"
    sha256 cellar: :any,                 arm64_linux:   "0167d5dd9d1067942f16c73bf401ea976953fa7ad8797a44c00e12eed97c9459"
    sha256 cellar: :any,                 x86_64_linux:  "aac472823fbd5f9c05a95b1c68d43d6308d77361eba0293364cb0b9acf9841c8"
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
    assert_equal "kamishibai 1.5.1", shell_output("#{bin}/kamishibai --version").strip
  end
end
