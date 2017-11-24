class WgetHalyard < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.19.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.19.2.tar.gz"
  sha256 "4f4a673b6d466efa50fbfba796bd84a46ae24e370fa562ede5b21ab53c11a920"

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  option "with-debug", "Build with debug support"

  depends_on "pkg-config-halyard" => :build
  depends_on "openssl-halyard"
  depends_on "pcre-halyard" => :optional
  depends_on "gpgme-halyard" => :optional

  conflicts_with "wget", :because => "wget-halyard replaces wget"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula["openssl-halyard"].opt_prefix}
    ]

    args << "--disable-debug" if build.without? "debug"
    args << "--disable-pcre" if build.without? "pcre"
    args << "--with-gpgme-prefix=#{Formula["gpgme-halyard"].opt_prefix}" if build.with? "gpgme"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
