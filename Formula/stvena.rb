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
      url "https://github.com/nccapo/stvena/releases/download/v0.1.6/stvena_darwin_arm64.tar.gz"
      sha256 "0d9743d1a37adbd11d3aae001b83d2798a46804f351895c682511927225b6b75"
    end

    on_intel do
      url "https://github.com/nccapo/stvena/releases/download/v0.1.6/stvena_darwin_amd64.tar.gz"
      sha256 "157bf166246d0b7a56433d5101b0c250a4490ffa0bce9dfb2448807303a9cd3f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nccapo/stvena/releases/download/v0.1.6/stvena_linux_arm64.tar.gz"
      sha256 "94372ab0054ff0c607d59f3d0a942dc46d970a132132cbf76e884d08670306a7"
    end

    on_intel do
      url "https://github.com/nccapo/stvena/releases/download/v0.1.6/stvena_linux_amd64.tar.gz"
      sha256 "f6db2fb10d7e0eb682fae8b7392ead4781c7751350fa5a5808c84f082c058ce0"
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
