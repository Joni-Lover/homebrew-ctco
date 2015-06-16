class Netxms < Formula
  desc "Network monitoring solution"
  homepage 'http://www.netxms.org/'
  url 'http://www.netxms.org/download/netxms-2.0-M4.tar.gz'
  sha256 '77ea23cb2e4048b8116284e15eef9ff13883f6e4f4253242f0707f50ff0b8390'
  version '2.0-M4'

#  bottle do
#    sha1 "aa312ee016437c22b7e4955c67defa51c7703540" => :yosemite
#    sha1 "400280627f03404732bf3db7a5612bfab5fe3876" => :mavericks
#    sha1 "9ac0bc82522ce93b349a71d2f0cfeac4d6501545" => :mountain_lion
#  end
 
  depends_on "curl" => :build

  def install
    cc_opt = "-I#{HOMEBREW_PREFIX}/include"
    ld_opt = "-L#{HOMEBREW_PREFIX}/lib"

    curl = Formula["curl"]
    cc_opt += " -I#{curl.include}"
    ld_opt += " -L#{curl.lib}"

    system "./configure",
           "--prefix=#{prefix}",
           "--exec-prefix=#{prefix}",
           "--with-snmp",
           "--with-agent",
           "--with-client",
           "--with-internal-libexpat",
           "--with-internal-libtre",
           "--with-internal-libjansson",
           "--with-internal-zlib",
           "--with-internal-getopt",
           "--with-all-static"

    system "make"
    system "make install"

    # Ensure var/run exists:
    (var + 'run').mkpath

    # Create the working directory:
    (opt_prefix + 'etc').mkpath
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>

      <key>OnDemand</key><false/>
      <key>KeepAlive</key><true/>
      <key>Disabled</key><false/>
      <key>RunAtLoad</key><true/>

      <key>Program</key>
      <string>#{bin}/nxagentd</string>

      <key>ProgramArguments</key>
      <array>
            <string>-c</string>
            <string>#{opt_prefix}/nxagentd.conf</string>
      </array>
    </dict>
    </plist>
    EOS
  end  
end

