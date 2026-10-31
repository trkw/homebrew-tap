# このファイルは trkw/sokkou の release.yml が scripts/make-cask.sh で書く。手で直さない
cask "sokkou" do
  version "0.1.55"
  sha256 "0ce14bd58433c319510479f3f1c1a5d4e22510a3cc2fca92a5ddb2f15341dc2a"

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
