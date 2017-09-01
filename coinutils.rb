class Coinutils < Formula
  desc "Utilities used by other Coin-OR projects"
  homepage "http://www.coin-or.org/projects/CoinUtils.xml"
  url "http://www.coin-or.org/download/pkgsource/CoinUtils/CoinUtils-2.10.10.tgz"
  sha256 "bedace82a76d4644efabb3a0bce03d5f00933a8500dbff084a7b7791aeb91561"
  revision 1

#  bottle do
#    root_url 'https://dl.bintray.com/dreal/homebrew-coinor'
#    sha256 "895ba0853d197ccaffcd6b435e60366cf4a47dc2eb876cb0b48925a27c5f7dc8" => :sierra
#  end

  option "with-glpk", "Build with support for reading AMPL/GMPL models" 

  depends_on :fortran

  depends_on "coin_data_sample"
  depends_on "coin_data_netlib"

  depends_on "doxygen"
  depends_on "graphviz" => :build  # For documentation.
  depends_on "pkg-config" => :build

  depends_on "homebrew/science/openblas" => :optional
  depends_on "homebrew/science/glpk448" if build.with? "glpk"

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
            "--with-dot",
           ]

    if build.with? "openblas"
      openblaslib = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      openblasinc = "#{Formula["openblas"].opt_include}"
      args << "--with-blas-lib=#{openblaslib}"
      args << "--with-blas-incdir=#{openblasinc}"
      args << "--with-lapack-lib=#{openblaslib}"
      args << "--with-lapack-incdir=#{openblasinc}"
    end

    if build.with? "glpk"
      args << "--with-glpk-lib=-L#{Formula["glpk448"].opt_lib} -lglpk"
      args << "--with-glpk-incdir=#{Formula["glpk448"].opt_include}"
    end

    system "./configure", *args

    system "make"
    ENV.deparallelize  # make install fails in parallel.
    system "make", "test"
    system "make", "install"
  end
end
