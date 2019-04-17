class Clp < Formula
  desc "Linear programming solver"
  homepage "https://projects.coin-or.org/Clp"
  url "https://www.coin-or.org/download/pkgsource/Clp/Clp-1.17.1.tgz"
  sha256 "304ddb7bf2fbf96a9378f9a8cc30ef5f0f309dd08096143987f094e76a945e7d"

  bottle do
    root_url "https://dl.bintray.com/dreal/homebrew-coinor"
    cellar :any
    sha256 "c01a501f6f2b1c8692134866d2afc894327cff3012a7e7796b381ccc1460bf96" => :sierra
    sha256 "30b5075242fe6d38ea3bf4aa378462a7ba97131ef2097ebc775fa17aa42f93f2" => :high_sierra
    sha256 "529bfe7f4b3ddd842ffb6b6e49514932b2a6065aeba225ade6647ed3419168a4" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "coinutils"
  depends_on "gcc"
  depends_on "readline" => :recommended

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
