#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# envをコピーしたあとの処理。
# envを最初から作るとインストール時間がかかる。短縮するためにコピーする。
# CreatedAt: 2021-07-09
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";

	# envディレクトリ一式をコピーしてくる
	# ...

	cd "$PARENT/env/bin"

	# envディレクトリ配下にある各ファイルに書かれているディレクトリ名を現在のディレクトリ名に変更する。
	SRC='Python.PySide2.QML.WebView.20210711090400'
	SED_SRC='Python\.PySide2\.QML\.WebView\.20210711090400'
	SED_DST='Python\.PySide2\.QML\.WebView\.loadHtml\.20210711103436'
	grep -l "$SRC" ./* | xargs sed -i.bak -e 's/'"$SED_SRC"'/'"$SED_DST"'/g'
	find . -name '*.bak' | xargs -I@ rm -f @
#	grep -l "'${SRC}'" ./* | xargs sed -e "'s/$SRC/$DST/g'"
#	grep -l 'Python\.PySide2\.QML\.PyOpenJTalk\.20210710090636' ./* | xargs sed -i.bak -e 's/Python\.PySide2\.QML\.PyOpenJTalk\.20210710090636/Python\.PySide2\.QML\.PyOpenJTalk\.FeedParser\.20210710133351/g'
}
Run "$@"
