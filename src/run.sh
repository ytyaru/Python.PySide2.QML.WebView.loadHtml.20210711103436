#!/usr/bin/env bash
set -Ceu
#---------------------------------------------------------------------------
# 実行する。
# CreatedAt: 2021-07-09
#---------------------------------------------------------------------------
Run() {
	THIS="$(realpath "${BASH_SOURCE:-0}")"; HERE="$(dirname "$THIS")"; PARENT="$(dirname "$HERE")"; THIS_NAME="$(basename "$THIS")"; APP_ROOT="$PARENT";
	cd "$HERE"
	. "${PARENT}/env/bin/activate"
	./run.py
}
Run "$@"
