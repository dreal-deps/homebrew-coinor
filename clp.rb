class Clp < Formula
  desc "Linear programming solver"
  homepage "https://projects.coin-or.org/Clp"
  url "https://www.coin-or.org/download/pkgsource/Clp/Clp-1.16.11.tgz"
  sha256 "ad02cfabd3f3b658ebc091bbbc00a6e8dbdfdb41399b35cd17faee5dcce1ada6"
  revision 1
  head "https://projects.coin-or.org/svn/Clp/trunk"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-coinor"
    cellar :any
    sha256 "d280f95737a05bcbaf6187dc15a9701a9b54ff1723260ee7790de4a17e85c7be" => :el_capitan
    sha256 "81d6ba25229cc9657d5f825145a3c9f2a5ffcd032ce806c118e46022e6d15cca" => :sierra
    sha256 "1884d4a36205b0469195ec87fedc3f45936c2340c49e3638f58273664ff38ffb" => :high_sierra
  end

  depends_on "coinutils"
  depends_on "readline" => :recommended
  depends_on "gcc"
  depends_on "pkg-config" => :build

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--datadir=#{pkgshare}",
            "--includedir=#{include}/clp",
            "--with-sample-datadir=#{Formula["coin_data_sample"].opt_pkgshare}/coin/Data/Sample",
            "--with-netlib-datadir=#{Formula["coin_data_netlib"].opt_pkgshare}/coin/Data/Netlib",
            "--with-dot"]

    system "./configure", *args

    system "make"
    ENV.deparallelize # make install fails in parallel.
    system "make", "test"
    system "make", "install"

    inreplace "#{lib}/pkgconfig/clp.pc", prefix, opt_prefix
  end

  test do
    nil
  end
end
