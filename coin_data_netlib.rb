class CoinDataNetlib < Formula
  desc "Netlib LP models"
  homepage "http://www.coin-or.org/download/pkgsource/Data"
  url "http://www.coin-or.org/download/pkgsource/Data/Data-Netlib-1.2.6.tgz"
  sha256 "dd687e5a35087ae0da825c5e24832b2ebaacc36a2ee73df084d4ef92e575e1ab"
  revision 1

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-coinor'
    cellar :any_skip_relocation
    # sha256 "cf461df7648973e7f5462dfd8559fb71de46cac63f3b814dccf13eaac6154bf8" => :el_capitan
    sha256 "395d159d32a1d1f974b9e3186b669c4fa22d4d2057330fcc2270abec3ba75e95" => :high_sierra
    # sha256 "abbf720fa8aeb4d3014157bd332390866c6adf544d3e8543a7dd5e1c49166a62" => :sierra
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
end
