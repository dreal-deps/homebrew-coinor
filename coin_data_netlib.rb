class CoinDataNetlib < Formula
  desc "Netlib LP models"
  homepage "http://www.coin-or.org/download/pkgsource/Data"
  url "http://www.coin-or.org/download/pkgsource/Data/Data-Netlib-1.2.6.tgz"
  sha256 "dd687e5a35087ae0da825c5e24832b2ebaacc36a2ee73df084d4ef92e575e1ab"
  
  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-coinor'
    cellar :any_skip_relocation
    sha256 "0fd1671d2fada5463b682053c511e5078599b8f559087b3ec63e6611b8b2ce44" => :high_sierra
    sha256 "abbf720fa8aeb4d3014157bd332390866c6adf544d3e8543a7dd5e1c49166a62" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           "--datadir=#{pkgshare}"
    system "make", "install"
  end
end
