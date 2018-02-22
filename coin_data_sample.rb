class CoinDataSample < Formula
  desc "Sample models"
  homepage "http://www.coin-or.org/download/pkgsource/Data"
  url "http://www.coin-or.org/download/pkgsource/Data/Data-Sample-1.2.10.tgz"
  sha256 "ec7de931a06126040910964b6ce89a3d0cf64132fdde187689cc13277e2c1985"
  revision 1

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-coinor'
    cellar :any_skip_relocation
    # sha256 "e79aecbd94f3439be9da59a6cb66ecdeb9d1600f994062f319237cf40f6534b6" => :el_capitan
    sha256 "0712f8c25ddbb6a9f6959cd20d21b3ea466a6b0fa75ceae3e153bfb55f65fddf" => :high_sierra
    # sha256 "d2080a3e8f76628c8445cf783eae0beee81d8ebeb837037692da421df93aadc2" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           "--datadir=#{pkgshare}"
    system "make", "install"

    inreplace "#{lib}/pkgconfig/coindatasample.pc", prefix, opt_prefix
  end
end
