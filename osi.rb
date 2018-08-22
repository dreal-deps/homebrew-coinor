class Osi < Formula
  desc "Abstract class to a generic linear programming solver"
  homepage "https://projects.coin-or.org/Osi/"
  url "https://www.coin-or.org/download/pkgsource/Osi/Osi-0.107.5.tgz"
  sha256 "c578256853109e33a8ad8f1917ca8850a027d8a0987ef87166d34de1a256a57d"
  revision 1

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-coinor"
    cellar :any
    sha256 "92eecd19cb42d83c3af251c6d59bf501f5f3055cca733a731b037201235cf542" => :el_capitan
    sha256 "f1c979594abae16bafa90fe33f8d9d7d0ad7abe09da19d38c4991fa050aa0577" => :sierra
    sha256 "fa7ff052cb881819cafdc989995c7960c7ebf53cbfd0dd602db97039223c8fee" => :high_sierra
  end

  depends_on "pkg-config" => :build

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--datadir=#{pkgshare}",
            "--includedir=#{include}/osi",
            "--with-sample-datadir=#{Formula["coin_data_sample"].opt_pkgshare}/coin/Data/Sample",
            "--with-netlib-datadir=#{Formula["coin_data_netlib"].opt_pkgshare}/coin/Data/Netlib",
            "--with-dot"]

    system "./configure", *args

    ENV.deparallelize # make fails in parallel.
    system "make"
    system "make", "test"
    system "make", "install"

    inreplace "#{lib}/pkgconfig/osi-unittests.pc", prefix, opt_prefix
    inreplace "#{lib}/pkgconfig/osi.pc", prefix, opt_prefix
  end

  test do
    nil
  end
end
