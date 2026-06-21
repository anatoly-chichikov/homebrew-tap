class Kamishibai < Formula
  desc "Turn a list of words into an illustrated anki deck with native-speaker audio"
  homepage "https://github.com/anatoly-chichikov/kamishibai"

  url "https://github.com/anatoly-chichikov/kamishibai/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "f2202a5d5e334c0ffea6080645f3ec1593efa22cf6a638f7b651802052c27085"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/anatoly-chichikov/homebrew-tap/releases/download/kamishibai-1.4.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10aa485d63702652d3ff97713cb96b91ebf53159927f2e701e164e34995f27cd"
    sha256 cellar: :any,                 arm64_linux:   "28e0299d74576876bdcb1a7ad2acc2e013b3d230fdbfd5af661bbb23c5ff85ba"
    sha256 cellar: :any,                 x86_64_linux:  "c722a02169521cbbb7c0c25214eefe5c97541c29392cfd05a958f9b93cd8c338"
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
    assert_equal "kamishibai 1.4.0", shell_output("#{bin}/kamishibai --version").strip
  end
end
