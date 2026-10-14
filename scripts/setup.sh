#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ $EUID -eq 0 ]]; then
    echo "Запусти сценарий обычным пользователем, не через sudo."
    exit 1
fi

echo "==> Шаг 1/4: подготовка yay"
./scripts/bootstrap-yay.sh

echo "==> Шаг 2/4: установка пакетов"
./scripts/install.sh

echo "==> Шаг 3/4: восстановление конфигураций"
./scripts/restore-configs.sh

echo "==> Шаг 4/4: настройка служб"
sudo systemctl enable NetworkManager.service greetd.service
systemctl --user enable dms.service
systemctl --user add-wants niri.service dms.service

echo
echo "Готово. Перезагрузка не выполнялась."
echo "Перед перезагрузкой проверь конфигурацию greetd и Niri."
