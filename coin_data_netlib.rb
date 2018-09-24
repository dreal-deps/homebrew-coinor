class CoinDataNetlib < Formula
  desc "Netlib LP models"
  homepage "https://www.coin-or.org/download/pkgsource/Data"
  url "https://www.coin-or.org/download/pkgsource/Data/Data-Netlib-1.2.6.tgz"
  sha256 "dd687e5a35087ae0da825c5e24832b2ebaacc36a2ee73df084d4ef92e575e1ab"
  revision 1

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-coinor"
    cellar :any_skip_relocation
    sha256 "395d159d32a1d1f974b9e3186b669c4fa22d4d2057330fcc2270abec3ba75e95" => :sierra
    sha256 "03c7b89cfa722989985618a4ee23072a838f47a66ec43269dd8b70bb18b21d27" => :high_sierra
    sha256 "58781a415d44556965f88285babb95cf6898fe350ebd64c3998556a892c68e75" => :mojave
  end

  def install
    system "./configure", "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}",
           "--datadir=#{pkgshare}"
    system "make", "install"

    inreplace "#{lib}/pkgconfig/coindatanetlib.pc", prefix, opt_prefix
  end

  test do
    nil
  end
end
