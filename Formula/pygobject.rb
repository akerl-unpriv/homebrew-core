class Pygobject < Formula
  desc "GNOME Python bindings (based on GObject Introspection)"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/3.30/pygobject-3.30.1.tar.xz"
  sha256 "e1335b70e36885bf1ae207ec1283a369b8fc3e080688046c1edb5a676edc11ce"

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "glib"
  depends_on "python@2"
  depends_on "python"
  depends_on "py2cairo"
  depends_on "py3cairo"
  depends_on "gobject-introspection"

  def install
    Language::Python.each_python(build) do |python, _version|
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "PYTHON=#{python}"
      system "make", "install"
      system "make", "clean"
    end
  end

  test do
    Pathname("test.py").write <<~EOS
      import gi
      assert("__init__" in gi.__file__)
    EOS
    Language::Python.each_python(build) do |python, pyversion|
      ENV.prepend_path "PYTHONPATH", lib/"python#{pyversion}/site-packages"
      system python, "test.py"
    end
  end
end
