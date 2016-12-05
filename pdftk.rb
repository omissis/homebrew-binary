require 'formula'

class PkgExtract < CurlDownloadStrategy
  def stage
    safe_system '/usr/bin/xar', '-xf', @tarball_path
    chdir
    safe_system 'mv *.pkg/Payload Payload.gz'
    safe_system 'ls | grep -v Payload | xargs rm -r'
  end
end

class Pdftk < Formula
  homepage 'http://www.pdflabs.com/tools/pdftk-server'
  url 'http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/pdftk_server-2.02-mac_osx-10.6-setup.pkg',
    :using => PkgExtract
  sha256 'c0679a7a12669480dd298c436b0e4d063966f95ed6a77b98d365bb8c86390d1b'

  depends_on :macos => :lion

  def install
    safe_system "pax --insecure -rz -f Payload.gz -s ',./bin,#{bin},' -s ',./man,#{man},' -s ',./lib,#{lib},' -s ',./license_gpl_pdftk,#{prefix}/LICENSE,' -s ',./,#{prefix}/README/,'"
  end

  test do
    system "#{bin}/pdftk --version"
  end
end
