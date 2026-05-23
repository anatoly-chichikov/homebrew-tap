class Kamishibai < Formula
  desc "Generate illustrated Anki decks from schema-driven vocabulary JSON"
  homepage "https://github.com/anatoly-chichikov/kamishibai"
  local_archive = "/Users/anatoly/Source/homebrew-tap/dist/kamishibai-1.0.0.tar.gz"
  if File.exist?(local_archive)
    url "file://#{local_archive}"
  else
    url "https://raw.githubusercontent.com/anatoly-chichikov/homebrew-tap/kamishibai-1.0.0/dist/kamishibai-1.0.0.tar.gz"
  end
  sha256 "a8ba56e13f40b4f24c89a8961cc2983758087fe20e98e4b302708ffb01073c06"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

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
