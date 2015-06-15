class NetxmsAgent < Formula
  desc "Network monitoring solution"
  homepage 'http://www.netxms.org/'
  url 'http://www.netxms.org/download/netxms-2.0-M4.tar.gz'
  sha256 '77ea23cb2e4048b8116284e15eef9ff13883f6e4f4253242f0707f50ff0b8390'

#  bottle do
#    sha1 "aa312ee016437c22b7e4955c67defa51c7703540" => :yosemite
#    sha1 "400280627f03404732bf3db7a5612bfab5fe3876" => :mavericks
#    sha1 "9ac0bc82522ce93b349a71d2f0cfeac4d6501545" => :mountain_lion
#  end
 
  depends_on "curl" => :build

  def install
    system "./configure", "CPP='gcc -E' CXXCPP='g++ -E'",
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
    (var + 'lib/netxms').mkpath
  end
  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>netxms.agent</string>

      <key>OnDemand</key><false/>
      <key>KeepAlive</key><true/>
      <key>Disabled</key><false/>
      <key>RunAtLoad</key><true/>

      <key>Program</key>
      <string>/opt/local/netxms/bin/nxagentd</string>

      <key>ProgramArguments</key>
      <array>
            <string>-c</string>
            <string>/opt/local/netxms/etc/nxagentd.conf</string>
      </array>
    </dict>
    </plist>
    EOS
  end  
end

