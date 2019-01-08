class Coinutils < Formula
  desc "Utilities used by other Coin-OR projects"
  homepage "https://projects.coin-or.org/CoinUtils"
  url "https://www.coin-or.org/download/pkgsource/CoinUtils/CoinUtils-2.10.14.tgz"
  sha256 "d18fa510ec3b3299d2da26660d7c7194e0f2be15199a5ff7f063e1454e23e40e"
  revision 2

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-coinor"
    cellar :any
    sha256 "da0b2a6dfa04fc923a38fd5c63c07ef175eb65b03e2d1ffcdfc383f5133c2897" => :sierra
    sha256 "5c37fcfce37ff2f779236f7054051b882f5637086318564f7f2476c694cebbbc" => :high_sierra
    sha256 "66667be7ce13ffbabd2c7bd14c02caf1e0106a648a64dcd36a789e07d849bfbf" => :mojave
  end

  depends_on "graphviz" => :build # For documentation.
  depends_on "pkg-config" => :build
  depends_on "coin_data_netlib"
  depends_on "coin_data_sample"
  depends_on "doxygen" => :build
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
