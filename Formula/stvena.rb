class Stvena < Formula
  desc "Live review workspace beside Codex and Claude Code in your terminal"
  homepage "https://github.com/nccapo/stvena"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # Stvena shells out to git for every review; macOS ships git, Linux may not.
  uses_from_macos "git"

  on_macos do
    on_arm do
      url "https://github.com/nccapo/stvena/releases/download/v0.1.5/stvena_darwin_arm64.tar.gz"
      sha256 "e16b4f4b5d073607b7602322900d51702f26314796bf86479ab1972af5e7f609"
    end

    on_intel do
      url "https://github.com/nccapo/stvena/releases/download/v0.1.5/stvena_darwin_amd64.tar.gz"
      sha256 "6f66bd130a814a654c07d2e2677f41650730ed8a7b3edd17078179062531744f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nccapo/stvena/releases/download/v0.1.5/stvena_linux_arm64.tar.gz"
      sha256 "1b2ad516623535d32350f1f67fdaee31d7dfe87c737b7d036f3ebdbfe32711d9"
    end

    on_intel do
      url "https://github.com/nccapo/stvena/releases/download/v0.1.5/stvena_linux_amd64.tar.gz"
      sha256 "ee8bbeaa4f6627cd9e1468965b1b74ab4639d76c73eea5e577d1e664b5d78112"
    end
  end

  def install
    bin.install "stvena"
  end

  def caveats
    <<~EOS
      Stvena runs inside a Git repository and drives your agent CLI in a PTY:

        cd /path/to/your/project
        stvena          # starts Codex
        stvena claude   # starts Claude Code

      Install and authenticate the agent CLI you want to use first.
      Native Windows is not supported.
    EOS
  end

  test do
    assert_match "stvena #{version}", shell_output("#{bin}/stvena --version")
    assert_match "Usage: stvena", shell_output("#{bin}/stvena --help")
  end
end
