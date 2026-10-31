# このファイルは trkw/sokkou の release.yml が scripts/make-cask.sh で書く。手で直さない
cask "sokkou" do
  version "0.1.57"
  sha256 "c3a34079a51efd9c2d484f4616043c2fa0b2af0c1cb8a2a0defc7b314a0ff6c6"

  url "https://github.com/trkw/sokkou/releases/download/v#{version}/sokkou-macos-arm64.dmg"
  name "sokkou"
  desc "SKK-flavoured Japanese input method that converts as you type"
  homepage "https://github.com/trkw/sokkou"

  livecheck do
    url :url
    strategy :github_latest
  end

  # sokkou は自分で新しいリリースに入れ替わる（入力メニューの「新しいリリースを自動で入れる」）
  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  # 入れる処理は sokkou 自身の --install に任せる（dmg から開いたときと同じ）。
  # ~/Library/Input Methods に写して入力ソースとして登録し、動いている古い版があれば入れ替えて起動し直す
  installer script: {
    executable: "sokkou.app/Contents/MacOS/sokkou",
    args:       ["--install"],
  }

  # sokkou 自身の --uninstall で、入力ソースから外して止め、入れた版と取っておいた前の版を消す
  uninstall script: {
              executable: "sokkou.app/Contents/MacOS/sokkou",
              args:       ["--uninstall"],
            },
            delete: "~/Library/Input Methods/sokkou.app"

  zap trash: [
    "~/Library/Application Support/sokkou",
    "~/Library/Logs/sokkou-update.log",
    "~/Library/Preferences/io.github.trkw.inputmethod.sokkou.plist",
  ]

  caveats <<~EOS
    入力ソースに「sokkou (日本語)」と「sokkou (英数)」を足しました。
    一覧に出ないときは、ログアウトしてログインし直してください。
  EOS
end
