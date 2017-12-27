class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "https://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.14.src.tar.gz"
  sha256 "d1757e02755ef6f56fd45f1f4398598b920381948d6fcfa58f5ca6aa56f59d4d"
  head "https://github.com/doxygen/doxygen.git"

  option "with-graphviz", "Build with dot command support from Graphviz."
  option "with-qt", "Build GUI frontend with Qt support."
  option "with-llvm", "Build with libclang support."

  depends_on "cmake" => :build
  depends_on "graphviz" => :optional
  depends_on "qt" => :optional
  depends_on "llvm" => :optional


  def install
    args = std_cmake_args << "-DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=#{MacOS.version}"
    args << "-Dbuild_wizard=ON" if build.with? "qt"
    args << "-Duse_libclang=ON -DLLVM_CONFIG=#{Formula["llvm"].opt_bin}/llvm-config" if build.with? "llvm"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
