class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.1.tar.gz"
  sha256 "8c744a5422dbffa0d1f92e90b34186fb8ed44db93fbacb55abd751ac8808d922"

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "giflib" => :optional
  depends_on "libtiff" => :optional


  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-gl",
      "--enable-libwebpmux",
      "--enable-libwebpdemux",
      "--enable-libwebpdecoder",
      "--prefix=#{prefix}",
    ]
    args << "--disable-gif" if build.without? "giflib"
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert_predicate testpath/"webp_test.webp", :exist?
  end
end
