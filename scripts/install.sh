#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

install_repo_list() {
    local file="$1"
    local -a packages=()

    [[ -f "$file" ]] || return 0

    mapfile -t packages < <(
        grep -vE '^[[:space:]]*(#|$)' "$file" || true
    )

    ((${#packages[@]})) || return 0

    echo "==> Пакеты из $file:"
    printf '  %s\n' "${packages[@]}"
    sudo pacman -S --needed -- "${packages[@]}"
}

install_aur_list() {
    local -a packages=()

    [[ -f packages/aur.txt ]] || return 0

    mapfile -t packages < <(
        grep -vE '^[[:space:]]*(#|$)' packages/aur.txt || true
    )

    ((${#packages[@]})) || return 0

    if ! command -v yay >/dev/null 2>&1; then
        echo "ОШИБКА: yay не установлен."
        echo "Сначала нужно установить yay, затем повторить запуск."
        exit 1
    fi

    echo "==> AUR-пакеты:"
    printf '  %s\n' "${packages[@]}"
    yay -S --needed -- "${packages[@]}"
}

install_repo_list packages/base.txt
install_repo_list packages/desktop.txt
install_repo_list packages/apps.txt
install_repo_list packages/hardware.txt
install_aur_list

echo "==> Установка пакетов завершена."
echo "Службы и конфигурационные файлы не изменялись."
