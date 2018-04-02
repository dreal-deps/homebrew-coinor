class CoinDataSample < Formula
  desc "Sample models"
  homepage "https://www.coin-or.org/download/pkgsource/Data"
  url "https://www.coin-or.org/download/pkgsource/Data/Data-Sample-1.2.10.tgz"
  sha256 "ec7de931a06126040910964b6ce89a3d0cf64132fdde187689cc13277e2c1985"
  revision 1

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-coinor"
    cellar :any_skip_relocation
    sha256 "eaeabf5132e4acbd564829f32e35decd2c60a65efcda63cb0c3ccea5bd393dab" => :el_capitan
    sha256 "0712f8c25ddbb6a9f6959cd20d21b3ea466a6b0fa75ceae3e153bfb55f65fddf" => :sierra
    sha256 "3722a7dfad53d3b1f2ae1780f8d072e30b0e955d0f577a50ec82acb8e3bb849d" => :high_sierra
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

  test do
    nil
  end
end
