class MynewtNewtmgr < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_4_0_tag.tar.gz"
  version "1.4.0"
  sha256 "d0a8c3a782714d5a7713f842c6fb71ae020b2dcd0883812d386a27035d24878b"

  head "https://github.com/apache/mynewt-newtmgr.git"

  bottle do
     root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.4.0"
     cellar :any_skip_relocation
    sha256 "1ae61b32dd1b36b19ed8ba50c38ab8825b5ab837561364bd0f87927947679d8a" => :sierra
  end

  depends_on "go" => :build
  depends_on :arch => :x86_64

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/mynewt.apache.org/newtmgr").install contents
    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

# We are not able to vendor these packages due to a "go get" bug in 
# vendoring packages with platform dependent code. So we have to get
# these packages for the buid.
  
    cd gopath/"src" do
       system "go", "get", "github.com/currantlabs/ble"
       system "go", "get", "github.com/raff/goble"
       system "go", "get", "github.com/mgutz/logxi/v1"
    end

    cd gopath/"src/mynewt.apache.org/newtmgr/newtmgr" do
      system "go", "install"
      bin.install gopath/"bin/newtmgr"
    end
  end

  test do
    # Check for Newtmgr in first word of output.
    assert_match "Newtmgr", shell_output("#{bin}/newtmgr").split.first
  end
end
