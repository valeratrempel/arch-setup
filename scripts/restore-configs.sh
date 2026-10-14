#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIGS="$ROOT/configs"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/arch-setup-backup-$STAMP"

mkdir -p "$HOME/.config"

backup_config() {
    local name="$1"
    local source="$HOME/.config/$name"

    if [[ -e "$source" ]]; then
        mkdir -p "$BACKUP/.config"
        cp -a "$source" "$BACKUP/.config/"
        echo "Резервная копия: $source"
    fi
}

for name in niri DankMaterialShell; do
    backup_config "$name"
done

for name in niri DankMaterialShell; do
    source="$CONFIGS/home/.config/$name"
    if [[ -d "$source" ]]; then
        cp -a "$source" "$HOME/.config/"
        echo "Восстановлен: $name"
    else
        echo "ПРЕДУПРЕЖДЕНИЕ: $source не найден, пропускаю."
    fi
done

if [[ -f "$CONFIGS/system/greetd-config.toml" ]]; then
    if sudo test -f /etc/greetd/config.toml; then
        sudo cp -a /etc/greetd/config.toml \
            "/etc/greetd/config.toml.backup-$STAMP"
    fi

    sudo install -m 644 "$CONFIGS/system/greetd-config.toml" \
        /etc/greetd/config.toml
    echo "Восстановлен конфиг greetd."
fi

echo "Готово. Резервные копии пользовательских конфигов: $BACKUP"
echo "Службы не перезапускались."
