class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.17.0/pycairo-1.17.0.tar.gz"
  sha256 "cdd4d1d357325dec3a21720b85d273408ef83da5f15c184f2eff3212ff236b9f"

  depends_on "pkg-config" => :build
  depends_on "cairo"


  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
