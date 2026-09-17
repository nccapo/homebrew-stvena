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
      url "https://github.com/nccapo/stvena/releases/download/v0.4.0/stvena_darwin_arm64.tar.gz"
      sha256 "62f4ebb76088e864c27f5ee361c98da50b3327d686ff2ae44f5d7f698d412e27"
    end

    on_intel do
      url "https://github.com/nccapo/stvena/releases/download/v0.4.0/stvena_darwin_amd64.tar.gz"
      sha256 "dc54575fbb8bd88bb9ae8ff1b6164983a14315d3ef23cd687b6cde2024c8ccb5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nccapo/stvena/releases/download/v0.4.0/stvena_linux_arm64.tar.gz"
      sha256 "afa0c76e5e0edff63fc6cd3113665aff8c55b2c1aa971b3bf2710d16e6652db1"
    end

    on_intel do
      url "https://github.com/nccapo/stvena/releases/download/v0.4.0/stvena_linux_amd64.tar.gz"
      sha256 "c22af66b01401e005986dbb697de89086c9bea3827850985db462d1a46062315"
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
