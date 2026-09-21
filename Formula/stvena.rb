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
      url "https://github.com/nccapo/stvena/releases/download/v0.4.1/stvena_darwin_arm64.tar.gz"
      sha256 "41aa6946bf4a9021107d40791fbaee11442b4aa49dbc4ad850d862bc82ddd63b"
    end

    on_intel do
      url "https://github.com/nccapo/stvena/releases/download/v0.4.1/stvena_darwin_amd64.tar.gz"
      sha256 "aba8690b3655a6fa9bfd8d63506f65e8e6247419941878f8467c14d21f40de80"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nccapo/stvena/releases/download/v0.4.1/stvena_linux_arm64.tar.gz"
      sha256 "0f30a0ac68708a6429391b6aec86166e31a5b886d9824b44793fea7da416cd2e"
    end

    on_intel do
      url "https://github.com/nccapo/stvena/releases/download/v0.4.1/stvena_linux_amd64.tar.gz"
      sha256 "1b12b19ac6054da58c7527d526fb57f941fa7b22c750298c6371796c752d65c0"
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
