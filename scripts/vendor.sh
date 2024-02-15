#!/bin/sh

MINI_COMMITISH="${MINI_COMMITISH:-main}"

set -ex

vendor_deps() {
	for mini in "basics" "deps" "ai" "comment" "pairs" "surround" "bufremove" "jump"; do
		wget "https://github.com/echasnovski/mini.nvim/raw/${MINI_COMMITISH}/lua/mini/${mini}.lua" -O "lua/_vendor/mini-${mini}.lua"
	done
}

test -d lua/_vendor && vendor_deps
