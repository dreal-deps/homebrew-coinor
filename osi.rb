class Osi < Formula
  desc "abstract class to a generic linear programming solver, and derived classes for specific solvers"
  homepage "https://projects.coin-or.org/Osi/"
  url "http://www.coin-or.org/download/pkgsource/Osi/Osi-0.107.5.tgz"
  sha256 "c578256853109e33a8ad8f1917ca8850a027d8a0987ef87166d34de1a256a57d"
  head "https://projects.coin-or.org/svn/Osi/trunk"
  revision 1

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-coinor'
    cellar :any
    # sha256 "47db5523a5635f575761aac801b18ceb29798545ac0604617497cbf1b9e15e8a" => :el_capitan
    sha256 "f1c979594abae16bafa90fe33f8d9d7d0ad7abe09da19d38c4991fa050aa0577" => :high_sierra
    # sha256 "e2095ca66d16620defd74a09feda94b1686aa29396ee1ae9f8f3dc6a8188af65" => :sierra
  end

  option "with-glpk", "Build with interface to GLPK and support for reading AMPL/GMPL models"

  glpk_dep = (build.with? "glpk") ? ["with-glpk"] : []
  openblas_dep = (build.with? "openblas") ? ["with-openblas"] : []

  depends_on "homebrew/science/openblas" => :optional
  depends_on "homebrew/science/glpk448" if build.with? "glpk"

  depends_on "coinutils" => (glpk_dep + openblas_dep)
  depends_on "pkg-config" => :build

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--datadir=#{pkgshare}",
            "--includedir=#{include}/osi",
            "--with-sample-datadir=#{Formula["coin_data_sample"].opt_pkgshare}/coin/Data/Sample",
            "--with-netlib-datadir=#{Formula["coin_data_netlib"].opt_pkgshare}/coin/Data/Netlib",
            "--with-dot",
           ]

    if build.with? "glpk"
      args << "--with-glpk-lib=-L#{Formula["glpk448"].opt_lib} -lglpk"
      args << "--with-glpk-incdir=#{Formula["glpk448"].opt_include}"
    end

    system "./configure", *args

    ENV.deparallelize # make fails in parallel.
    system "make"
    system "make", "test"
    system "make", "install"

    inreplace "#{lib}/pkgconfig/osi-unittests.pc", prefix, opt_prefix
    inreplace "#{lib}/pkgconfig/osi.pc", prefix, opt_prefix
  end
end
