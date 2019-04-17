class Coinutils < Formula
  desc "Utilities used by other Coin-OR projects"
  homepage "https://projects.coin-or.org/CoinUtils"
  url "https://www.coin-or.org/download/pkgsource/CoinUtils/CoinUtils-2.11.1.tgz"
  sha256 "1814d6266d00b313fe07fe8b011528243df27c033e7cc630e4a05929da4acaa0"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-coinor"
    cellar :any
    sha256 "c251af9ce6a8a66eaeee6135c2f700d4e51409f0f4f5a376cd9cabbf0eb1f1a7" => :sierra
    sha256 "a01cf46c2d53db616f8bde4f715b7ed6fc09bf488ef3f0dde0a10ddb3e5e8435" => :high_sierra
    sha256 "8843b5a42a337e668c8212571ab1a436bb83de7c94af97958ce930b6d0f1d40c" => :mojave
  end

  depends_on "graphviz" => :build # For documentation.
  depends_on "pkg-config" => :build
  depends_on "coin_data_netlib"
  depends_on "coin_data_sample"
  depends_on "doxygen" => :build
  depends_on "gcc"

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
