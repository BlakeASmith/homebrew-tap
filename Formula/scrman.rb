class Scrman < Formula
  desc "Script manager - Create and manage scripts in multiple languages"
  homepage "https://github.com/BlakeASmith/scrman"
  url "https://github.com/BlakeASmith/scrman/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "990d3effbd6b0f875d937cf5858b779476642ec1830b4fd1415b306ce60e7812"
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
    
    # Install the main executable to libexec
    libexec.install "bin/scrman"
    
    # Create wrapper script that sets up gem environment and load paths
    (bin/"scrman").write <<~EOS
      #!/bin/bash
      export GEM_HOME="#{libexec}"
      export GEM_PATH="#{libexec}"
      exec "#{Formula["ruby"].opt_bin}/ruby" -I"#{libexec}" "#{libexec}/scrman" "$@"
    EOS
  end

  test do
    system "#{bin}/scrman", "help"
  end
end

