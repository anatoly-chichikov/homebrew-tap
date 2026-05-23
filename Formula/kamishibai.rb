class Kamishibai < Formula
  desc "Turn a list of words into an illustrated anki deck with native-speaker audio"
  homepage "https://github.com/anatoly-chichikov/kamishibai"

  local_archive = Pathname(__dir__).parent/"dist/kamishibai-1.0.0.tar.gz"
  if File.exist?(local_archive)
    url "file://#{local_archive}"
  else
    url "https://raw.githubusercontent.com/anatoly-chichikov/homebrew-tap/kamishibai-1.0.0/dist/kamishibai-1.0.0.tar.gz"
  end
  sha256 "3c2108464618697c635697e6551d80581b954b58004ac437e40b3a48e4d3e2a4"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/anatoly-chichikov/homebrew-tap/releases/download/kamishibai-1.0.0"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fde0e704365d3a3c7a458e0da4f8b623b2fb25c2060a9f8a7fb2074533965add"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0650c3de33c1b1f4ea16af76c0a0418c1a1d6fe0893d3dafb13c6192084d96d"
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
    assert_equal "kamishibai 1.0.0", shell_output("#{bin}/kamishibai --version").strip
  end
end
