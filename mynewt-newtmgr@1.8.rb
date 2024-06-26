# typed: false
# frozen_string_literal: true

class MynewtNewtmgrAT18 < Formula
  desc "Tool to manage devices running Mynewt OS via the Newtmgr Protocol"
  homepage "https://mynewt.apache.org"
  url "https://github.com/apache/mynewt-newtmgr/archive/mynewt_1_8_0_tag.tar.gz"
  version "1.8.0"
  sha256 "e6fe6cd133214ded12460a380c39f6ff3431c7ea91e45d8cded1b501e7500604"

  bottle do
    root_url "https://github.com/JuulLabs-OSS/binary-releases/raw/master/mynewt-newt-tools_1.8.0"
    sha256 cellar: :any_skip_relocation, big_sur: "d7abe378aebcca72b7ebdca343b2eb401e5b721762d25b670cf8926aeb543bbf"
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
