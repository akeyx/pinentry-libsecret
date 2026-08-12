#!/usr/bin/env bash
# pinentry-libsecret One-Line Installer Script
# Usage: curl -sSL https://raw.githubusercontent.com/akeyx/pinentry-libsecret/main/install.sh | bash

set -e

REPO_RAW_URL="https://raw.githubusercontent.com/akeyx/pinentry-libsecret/main/pinentry-libsecret"
TARGET_DIR="$HOME/.local/bin"
TARGET_PATH="$TARGET_DIR/pinentry-libsecret"

echo "==> Installing pinentry-libsecret to $TARGET_PATH..."

mkdir -p "$TARGET_DIR"
curl -sSL "$REPO_RAW_URL" -o "$TARGET_PATH"
chmod +x "$TARGET_PATH"

# Check if ~/.gnupg/gpg-agent.conf needs updating
GPG_CONF="$HOME/.gnupg/gpg-agent.conf"
mkdir -p "$HOME/.gnupg"

if [ -f "$GPG_CONF" ] && grep -q "pinentry-program" "$GPG_CONF"; then
    echo "==> Existing pinentry-program found in $GPG_CONF."
    echo "==> Updating pinentry-program path..."
    sed -i.bak 's|^pinentry-program .*|pinentry-program '"$TARGET_PATH"'|g' "$GPG_CONF"
else
    echo "==> Setting pinentry-program in $GPG_CONF..."
    echo "pinentry-program $TARGET_PATH" >> "$GPG_CONF"
fi

echo "==> Reloading gpg-agent..."
gpgconf --kill gpg-agent 2>/dev/null || true

echo ""
echo "✅ Installation complete!"
echo "   Executable: $TARGET_PATH"
echo "   Configured: $GPG_CONF"
