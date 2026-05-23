class Kamishibai < Formula
  desc "Turn a list of words into an illustrated anki deck with native-speaker audio"
  homepage "https://github.com/anatoly-chichikov/kamishibai"

  bottle do
    root_url "https://github.com/anatoly-chichikov/homebrew-tap/releases/download/kamishibai-1.0.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3812139c13a958426a527f2e5b78af7669bf947b05337ba09ac0ca3aaff97328"
  end
  local_archive = Pathname(__dir__).parent/"dist/kamishibai-1.0.0.tar.gz"
  if File.exist?(local_archive)
    url "file://#{local_archive}"
  else
    url "https://raw.githubusercontent.com/anatoly-chichikov/homebrew-tap/kamishibai-1.0.0/dist/kamishibai-1.0.0.tar.gz"
  end
  sha256 "3c2108464618697c635697e6551d80581b954b58004ac437e40b3a48e4d3e2a4"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on :macos

  resource "mnn-prebuilt" do
    url "https://github.com/zibo-chen/MNN-Prebuilds/releases/download/dev/mnn-dev-macos-universal.tar.gz"
    sha256 "e2a5e38b3ad6e5212208fbed66f63f0487fee6d01fab973a28370cb18ebd2233"
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
