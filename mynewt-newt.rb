class MynewtNewt < Formula
  desc "Package, build and installation system for Mynewt OS applications"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newt/archive/mynewt_1_4_0_tag.tar.gz"
  version "1.4.0"
  sha256 "075ffc72d2b6d83dd3b28ab0f5b4767856ba6f30cddb2b32e488f82113a1f680"

  head "https://github.com/apache/mynewt-newt.git"

  bottle do
    root_url "https://github.com/runtimeco/binary-releases/raw/master/mynewt-newt-tools_1.4.0"
    cellar :any_skip_relocation
    sha256 "855bc2601921f0a069c12cd4280989a758a6638d1b70d25edf45c269863cb06b" => :sierra
  end

  depends_on "go" => :build
  depends_on :arch => :x86_64

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/mynewt.apache.org/newt").install contents
    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    cd gopath/"src/mynewt.apache.org/newt/newt" do
      system "go", "install"
      bin.install gopath/"bin/newt"
    end
  end

  test do
    # Compare newt version string
    assert_equal "1.4.0", shell_output("#{bin}/newt version").split.last
  end
end
