class Scrman < Formula
  desc "Script manager - Create and manage scripts in multiple languages"
  homepage "https://github.com/BlakeASmith/scrman"
  url "https://github.com/BlakeASmith/scrman/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "2557af5b116f7ab0d12e5172b47e27a0cd2b736b58a77a044caa46c96ce3c314"
  license "MIT"
  head "https://github.com/BlakeASmith/scrman.git", branch: "main"

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec

    # Install the gem dependencies
    system "gem", "install", "thor", "-v", "~> 1.4", "--no-document",
           "--install-dir", libexec

    # Install library files
    libexec.install Dir["lib/*"]
    
    # Create wrapper script that sets up gem environment and load paths
    (bin/"scrman").write <<~EOS
      #!/bin/bash
      export GEM_HOME="#{libexec}"
      export GEM_PATH="#{libexec}"
      exec "#{Formula["ruby"].opt_bin}/ruby" -I"#{libexec}" "#{libexec}/scrman" "$@"
    EOS
    
    # Install the main executable to libexec
    (libexec/"scrman").install "bin/scrman"
    chmod 0755, libexec/"scrman"
  end

  test do
    system "#{bin}/scrman", "help"
  end
end

