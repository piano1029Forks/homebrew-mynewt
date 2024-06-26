# typed: false
# frozen_string_literal: true

class MynewtNewtmgrAT17 < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_7_0_tag.tar.gz"
  version "1.7.0"
  sha256 "7aaa8c1c6899a9f39957b51e69d02d5c202a58fa104efcdc5bae75d4691b8c2f"

  bottle do
    root_url "https://github.com/JuulLabs-OSS/binary-releases/raw/master/mynewt-newt-tools_1.7.0"
    sha256 cellar: :any_skip_relocation, high_sierra: "8f772a9cb14018f268effff2c33c492f1894416178dbb6c390e502c3e91ff6bc"
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/mynewt.apache.org/newtmgr").install contents

    cd gopath/"src/mynewt.apache.org/newtmgr/newtmgr" do
      system "go", "build"
      bin.install "newtmgr"
    end
  end

  test do
    # Check for Newtmgr in first word of output.
    assert_match "Newtmgr", shell_output("#{bin}/newtmgr").split.first
  end
end
