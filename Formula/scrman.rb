class Scrman < Formula
  desc "Script manager - Create and manage scripts in multiple languages"
  homepage "https://github.com/BlakeASmith/scrman"
  url "https://github.com/BlakeASmith/scrman/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "08377b7cb63654672dd14fca8dade237605b583ed18d587864d42e950b521acf"
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

