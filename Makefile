# dotfiles — GNU make (brew) + PATH 設定で Xcode 不要
# 初回で make 自体が無い場合は先に: brew install make
# またはこのリポジトリ直下で ./install.sh

SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help setup

help:
	@echo "Targets:"
	@echo "  setup  — dotfiles をデプロイ（install.sh と同等）"

setup:
	@./install.sh
