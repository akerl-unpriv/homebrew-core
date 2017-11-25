class Icu4cHalyard < Formula
  desc "C/C++ and Java libraries for Unicode and globalization"
  homepage "http://site.icu-project.org/"
  revision 1
  head "https://ssl.icu-project.org/repos/icu/trunk/icu4c/", :using => :svn

  stable do
    url "https://ssl.icu-project.org/files/icu4c/59.1/icu4c-59_1-src.tgz"
    mirror "https://fossies.org/linux/misc/icu4c-59_1-src.tgz"
    mirror "https://downloads.sourceforge.net/project/icu/ICU4C/59.1/icu4c-59_1-src.tgz"
    version "59.1"
    sha256 "7132fdaf9379429d004005217f10e00b7d2319d0fea22bdfddef8991c45b75fe"

    # Fix CVE-2017-14952
    # Upstream commit from 9 Aug 2017 "Removed redundant UVector entry clean up
    # function call."
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/fb441ea/icu4c/CVE-2017-14952.diff"
      sha256 "1da1eec19cfe4907eb4766192ddbca689506ce44cfeb35c349af9609ae7f7203"
    end
  end

  keg_only :provided_by_osx, "macOS provides libicucore.dylib (but nothing else)"

  conflicts_with "icu4c", :because => "icu4c-halyard replaces icu4c"

  def install
    args = %W[--prefix=#{prefix} --disable-samples --disable-tests --enable-static]
    args << "--with-library-bits=64" if MacOS.prefer_64_bit?

    cd "source" do
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/gendict", "--uchars", "/usr/share/dict/words", "dict"
  end
end