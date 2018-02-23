class Clp < Formula
  desc "Linear programming solver"
  homepage "https://projects.coin-or.org/Clp"
  url "http://www.coin-or.org/download/pkgsource/Clp/Clp-1.16.11.tgz"
  sha256 "ad02cfabd3f3b658ebc091bbbc00a6e8dbdfdb41399b35cd17faee5dcce1ada6"
  head "https://projects.coin-or.org/svn/Clp/trunk"
  revision 1

  bottle do
    root_url 'https://dl.bintray.com/dreal/homebrew-coinor'
    cellar :any
    sha256 "d280f95737a05bcbaf6187dc15a9701a9b54ff1723260ee7790de4a17e85c7be" => :el_capitan
    sha256 "81d6ba25229cc9657d5f825145a3c9f2a5ffcd032ce806c118e46022e6d15cca" => :sierra
    sha256 "1884d4a36205b0469195ec87fedc3f45936c2340c49e3638f58273664ff38ffb" => :high_sierra
  end

  option "with-glpk", "Build with support for reading AMPL/GMPL models"

  glpk_dep = (build.with? "glpk") ? ["with-glpk"] : []
  openblas_dep = (build.with? "openblas") ? ["with-openblas"] : []

  depends_on "homebrew/science/openblas" => :optional
  depends_on "homebrew/science/glpk448" if build.with? "glpk"
  depends_on "homebrew/science/asl" => :optional
  depends_on "homebrew/science/mumps" => [:optional, "without-mpi"] + openblas_dep

  ss_opts = openblas_dep.clone
  ss_opts << :optional if build.without? "glpk"
  depends_on "homebrew/science/suite-sparse" => ss_opts

  depends_on "coinutils"
  depends_on "osi" => (glpk_dep + openblas_dep)

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

    if build.with? "openblas"
      openblaslib = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      openblasinc = Formula["openblas"].opt_include.to_s
      args << "--with-blas-lib=#{openblaslib}"
      args << "--with-blas-incdir=#{openblasinc}"
      args << "--with-lapack-lib=#{openblaslib}"
      args << "--with-lapack-incdir=#{openblasinc}"
    end

    if build.with? "glpk"
      args << "--with-glpk-lib=-L#{Formula["glpk448"].opt_lib} -lglpk"
      args << "--with-glpk-incdir=#{Formula["glpk448"].opt_include}"
    end

    if build.with? "asl"
      args << "--with-asl-incdir=#{Formula["asl"].opt_include}/asl"
      args << "--with-asl-lib=-L#{Formula["asl"].opt_lib} -lasl"
    end

    if build.with? "mumps"
      mumps_libs = %w[-ldmumps -lmumps_common -lpord -lmpiseq]
      mumps_libcmd = "-L#{Formula["mumps"].opt_lib} " + mumps_libs.join(" ")
      args << "--with-mumps-incdir=#{Formula["mumps"].opt_libexec}/include"
      args << "--with-mumps-lib=#{mumps_libcmd}"
    end

    if (build.with? "glpk") || (build.with? "suite-sparse")
      args << "--with-amd-incdir=#{Formula["suite-sparse"].opt_include}"
      args << "--with-amd-lib=-L#{Formula["suite-sparse"].opt_lib} -lamd"
      args << "--with-cholmod-incdir=#{Formula["suite-sparse"].opt_include}"
      args << "--with-cholmod-lib=-L#{Formula["suite-sparse"].opt_lib} -lcolamd -lcholmod -lsuitesparseconfig"
    end

    system "./configure", *args

    system "make"
    system "make", "test"
    ENV.deparallelize # make install fails in parallel.
    system "make", "install"

    inreplace "#{lib}/pkgconfig/clp.pc", prefix, opt_prefix
    inreplace "#{lib}/pkgconfig/osi-clp.pc", prefix, opt_prefix
  end
end
