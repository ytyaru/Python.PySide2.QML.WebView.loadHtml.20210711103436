#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# ラズパイにQtとPySide2をインストールする。
# CreatedAt: 2021-07-09
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	QtVersion() { qmake -query QT_VERSION; }
	IsExistCmd() { type $1 >/dev/null 2>&1; }
#	IsExistPkg() { dpkg -l | grep '^ii' | grep $1; }
#	IsExistPkg() { apt list --installed 2>/dev/null | grep $1; }
	IsExistPkg() { apt list --installed 2>/dev/null | grep python3-pyside2.qtcore 1>/dev/null && return 0 || return 1; }
	InstallQt() {
		IsExistCmd qmake && return
		sudo apt update
		sudo apt -y install build-essential git cmake qt-sdk libgl1-mesa-dev qt5-default libxml2 libxslt1.1 python-dev qtbase5-dev
		sudo apt -y install qttools5-dev-tools libqt5clucene5 libqt5concurrent5 libqt5core5a libqt5dbus5 libqt5designer5 libqt5designercomponents5 libqt5feedback5 libqt5gui5 libqt5help5 libqt5multimedia5 libqt5network5 libqt5opengl5 libqt5opengl5-dev libqt5organizer5 libqt5positioning5 libqt5printsupport5 libqt5qml5 libqt5quick5 libqt5quickwidgets5 libqt5script5 libqt5scripttools5 libqt5sql5 libqt5sql5-sqlite libqt5svg5 libqt5test5 libqt5webkit5 libqt5widgets5 libqt5xml5 libqt5xmlpatterns5 libqt5xmlpatterns5-dev 
		sudo apt -y install qml-module-qtquick-controls2 qml-module-qtquick-dialogs qtdeclarative5-dev qml-module-qtquick-xmllistmodel qtmultimedia5-dev qml-module-qtmultimedia libzbar-dev qml-module-qtquick-templates2
		sudo apt -y install qml-module-qtwebkit
#		sudo apt -y install qml-module-qtquick-controls qml-module-qtquick-layouts qml-module-qtquick-window2
#		sudo apt -y install libqt5webview5 qml-module-qtwebview
	}
	InstallQt
	QtVersion
	# https://stackoverflow.com/questions/58743664/why-do-i-keep-getting-errors-when-i-try-to-install-pyside2-on-windows-pc
	# https://forum.qt.io/topic/112813/installing-pyside2-on-raspberry-pi/6
	InstallPySide2() {
		IsExistPkg python3-pyside2.qtcore && return
		sudo apt -y install python3-pyside2.qt3dcore python3-pyside2.qt3dinput python3-pyside2.qt3dlogic python3-pyside2.qt3drender python3-pyside2.qtcharts python3-pyside2.qtconcurrent python3-pyside2.qtcore python3-pyside2.qtgui python3-pyside2.qthelp python3-pyside2.qtlocation python3-pyside2.qtmultimedia python3-pyside2.qtmultimediawidgets python3-pyside2.qtnetwork python3-pyside2.qtopengl python3-pyside2.qtpositioning python3-pyside2.qtprintsupport python3-pyside2.qtqml python3-pyside2.qtquick python3-pyside2.qtquickwidgets python3-pyside2.qtscript python3-pyside2.qtscripttools python3-pyside2.qtsensors python3-pyside2.qtsql python3-pyside2.qtsvg python3-pyside2.qttest python3-pyside2.qttexttospeech python3-pyside2.qtuitools python3-pyside2.qtwebchannel python3-pyside2.qtwebsockets python3-pyside2.qtwidgets python3-pyside2.qtx11extras python3-pyside2.qtxml python3-pyside2.qtxmlpatterns python3-pyside2uic
	}
	InstallPySide2
	InstallPyOpenJTalk() {
		# 仮想環境をつくる
		cd "$PARENT"
		[ -d ./env ] && return
		python3 -m venv env --system-site-packages

		. "${PARENT}/env/bin/activate"
		pip install numpy
		pip install Cython
		pip install six
		pip install simpleaudio
		pip install feedparser
		pip install marko

		# ソースコードを取得する
		cd "$HERE"
		git clone https://github.com/ytyaru/pyopenjtalk
		cd pyopenjtalk
		git submodule update -i

		# ビルド＆インストールする。
		python3 setup.py install

		# ソースコードを削除する
		cd ../
		rm -rf pyopenjtalk
	}
	InstallPyOpenJTalk
}
Run "$@"
