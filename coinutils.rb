class Coinutils < Formula
  desc "Utilities used by other Coin-OR projects"
  homepage "https://projects.coin-or.org/CoinUtils"
  url "https://www.coin-or.org/download/pkgsource/CoinUtils/CoinUtils-2.10.14.tgz"
  sha256 "d18fa510ec3b3299d2da26660d7c7194e0f2be15199a5ff7f063e1454e23e40e"
  revision 1

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-coinor"
    cellar :any
    sha256 "c59ad3d741d9e0bbe7fe1625b84f70248f92cedfab2000b9b51a922b2b470598" => :el_capitan
    sha256 "1cdaedb187307fc10cc47f314cdf53794286534ceb546a28f2603718d88098d6" => :sierra
    sha256 "3e0b777a567b0906b94835720503ceab4f3bb1a6fdc66366a0edddbc3d79e38f" => :high_sierra
  end

  depends_on "graphviz" => :build # For documentation.
  depends_on "pkg-config" => :build
  depends_on "coin_data_netlib"
  depends_on "coin_data_sample"
  depends_on "doxygen"
  depends_on "gcc"

  patch do
    url "https://raw.githubusercontent.com/dreal-deps/homebrew-coinor/master/coinutils_coinhelperfunctions_no_register.patch"
    sha256 "ff6e052c4ef478d3e86f51644d91e96fbd5f3bd161a2ec20a04d49c42bd34e3f"
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--datadir=#{pkgshare}",
            "--includedir=#{include}/coinutils",
            "--with-sample-datadir=#{Formula["coin_data_sample"].opt_pkgshare}/coin/Data/Sample",
            "--with-netlib-datadir=#{Formula["coin_data_netlib"].opt_pkgshare}/coin/Data/Netlib",
            "--with-dot"]

    system "./configure", *args

    system "make"
    ENV.deparallelize # make install fails in parallel.
    system "make", "test"
    system "make", "install"

    inreplace "#{lib}/pkgconfig/coinutils.pc", prefix, opt_prefix
  end

  test do
    nil
  end
end
