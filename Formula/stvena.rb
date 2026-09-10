class Stvena < Formula
  desc "Live review workspace beside Codex and Claude Code in your terminal"
  homepage "https://github.com/nccapo/stvena"
  version "0.1.4"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  # Stvena shells out to git for every review; macOS ships git, Linux may not.
  uses_from_macos "git"

  on_macos do
    on_arm do
      url "https://github.com/nccapo/stvena/releases/download/v0.1.4/stvena_darwin_arm64.tar.gz"
      sha256 "6d3a9fe81ee1ee8ccfcc391a4ef1e0758d1cfade6d951ea5cfb2ccbf0ad48c89"
    end

    on_intel do
      url "https://github.com/nccapo/stvena/releases/download/v0.1.4/stvena_darwin_amd64.tar.gz"
      sha256 "ab3d8828a79c62508222f69173ee064ae727a3d3f949a6b49018cec257d6c3f3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nccapo/stvena/releases/download/v0.1.4/stvena_linux_arm64.tar.gz"
      sha256 "0c3a24d214aba28b36909a63420da4f9c2a8bb032e4e28dd8dd9382a6ebc403a"
    end

    on_intel do
      url "https://github.com/nccapo/stvena/releases/download/v0.1.4/stvena_linux_amd64.tar.gz"
      sha256 "b03eda9f2c9c83c1a6c7079bf505f70c6e6e41fac65082435e53e9f757f921b9"
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
