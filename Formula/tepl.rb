class Tepl < Formula
  desc "GNOME Text Editor Product Line"
  homepage "https://wiki.gnome.org/Projects/Tepl"
  url "https://download.gnome.org/sources/tepl/4.2/tepl-4.2.0.tar.xz"
  sha256 "8839d4428ecdd87fd5abc657ebbe5a9601a57262e9946845e47dec264e669ccd"

  bottle do
    sha256 "6b809b7405ea082477b7e1831c23556b699e8eb7a810c02db9ff5d7b42d14463" => :mojave
    sha256 "30acd42fc1301c7fa1799240b2526406028b9f8208a9020b51ce2a88e0712e39" => :high_sierra
    sha256 "c1bbb1bacd6541f60210a4ba994db42fb8d829944ffe1d1586bd9b2da273e0d3" => :sierra
    sha256 "ad0b8dfe43a8d18454e92f978636b91d2c0d08164e6e407f29be9ea5320c00d6" => :el_capitan
    sha256 "03ded32558742913fff00af2f0874c07c6f1db49df8ba072ad0fe27eea94e02c" => :x86_64_linux
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "amtk"
  depends_on "gtksourceview@4"
  depends_on "uchardet"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tepl/tepl.h>

      int main(int argc, char *argv[]) {
        GType type = tepl_file_get_type();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    amtk = Formula["amtk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx3 = Formula["gtk+3"]
    gtksourceview4 = Formula["gtksourceview@4"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pcre = Formula["pcre"]
    pixman = Formula["pixman"]
    uchardet = Formula["uchardet"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    amtklib = OS.mac? ? "amtk-5.0" : "amtk-5"
    gtksourceviewlib = OS.mac? ? "gtksourceview-4.0" : "gtksourceview-4"
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{amtk.opt_include}/amtk-5
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtksourceview4.opt_include}/gtksourceview-4
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/tepl-4
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pcre.opt_include}
      -I#{pixman.opt_include}/pixman-1
      -I#{uchardet.opt_include}/uchardet
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{amtk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtksourceview4.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -l#{amtklib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -ltepl-4
      -l#{gtksourceviewlib}
      -lgtk-3
      -lpango-1.0
      -lpangocairo-1.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
