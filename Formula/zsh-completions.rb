class ZshCompletions < Formula
  desc "Additional completion definitions for zsh"
  homepage "https://github.com/zsh-users/zsh-completions"
  url "https://github.com/zsh-users/zsh-completions/archive/0.29.0.tar.gz"
  sha256 "979604ea4e729e9bf2f19895545a7064e8d723cd93e9fa0d4402ca8a915e74d1"

  head "https://github.com/zsh-users/zsh-completions.git"


  def install
    pkgshare.install Dir["src/_*"]
  end

  def caveats
    <<~EOS
      To activate these completions, add the following to your .zshrc:

        fpath=(#{HOMEBREW_PREFIX}/share/zsh-completions $fpath)

      You may also need to force rebuild `zcompdump`:

        rm -f ~/.zcompdump; compinit

      Additionally, if you receive "zsh compinit: insecure directories" warnings when attempting
      to load these completions, you may need to run this:

        chmod go-w '#{HOMEBREW_PREFIX}/share'
    EOS
  end

  test do
    (testpath/"test.zsh").write <<~EOS
      fpath=(#{pkgshare} $fpath)
      autoload _ack
      which _ack
    EOS
    assert_match /^_ack/, shell_output("/bin/zsh test.zsh")
  end
end
