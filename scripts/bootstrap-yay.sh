#!/usr/bin/env bash
set -Eeuo pipefail

if command -v yay >/dev/null 2>&1; then
    echo "yay уже установлен: $(yay --version | head -n 1)"
    exit 0
fi

sudo pacman -S --needed -- git base-devel

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

git clone https://aur.archlinux.org/yay.git "$WORKDIR/yay"
cd "$WORKDIR/yay"

makepkg -si --needed
echo "==> yay установлен."
