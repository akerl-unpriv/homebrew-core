class PangoHalyard < Formula
  desc "Framework for layout and rendering of i18n text"
  homepage "http://www.pango.org/"
  url "https://download.gnome.org/sources/pango/1.40/pango-1.40.14.tar.xz"
  sha256 "90af1beaa7bf9e4c52db29ec251ec4fd0a8f2cc185d521ad1f88d01b3a6a17e3"

  head do
    url "https://git.gnome.org/browse/pango.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "harfbuzz"


  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-html-dir=#{share}/doc",
                          "--enable-introspection=yes",
                          "--enable-man",
                          "--enable-static",
                          "--without-xft"

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pango-view", "--version"
    (testpath/"test.c").write <<~EOS
      #include <pango/pangocairo.h>

      int main(int argc, char *argv[]) {
        PangoFontMap *fontmap;
        int n_families;
        PangoFontFamily **families;
        fontmap = pango_cairo_font_map_get_default();
        pango_font_map_list_families (fontmap, &families, &n_families);
        g_free(families);
        return 0;
      }
    EOS
    cairo = Formula["cairo-halyard"]
    fontconfig = Formula["fontconfig-halyard"]
    freetype = Formula["freetype-halyard"]
    gettext = Formula["gettext-halyard"]
    glib = Formula["glib-halyard"]
    libpng = Formula["libpng-halyard"]
    pixman = Formula["pixman-halyard"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/pango-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lcairo
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
