#!/bin/bash
set -euo pipefail

ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  ASSET_FILTER="linux-x64.tar.gz" ;;
    aarch64) ASSET_FILTER="linux-arm64.tar.gz" ;;
    *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;;
esac

URL=$(curl -fsSL "https://api.github.com/repos/LuaLS/lua-language-server/releases/latest" \
    | grep -o "\"browser_download_url\": *\"[^\"]*${ASSET_FILTER}\"" \
    | head -1 \
    | sed 's/"browser_download_url": *"//; s/"$//')

if [[ -z "$URL" ]]; then
    echo "Error: Could not find a release asset matching '$ASSET_FILTER'" >&2
    exit 1
fi

echo "Downloading: $URL"
curl -fSL "$URL" -o /tmp/lua-language-server.tar.gz

# Install to /usr/local
mkdir -p /usr/local/share/lua-language-server
tar -xzf /tmp/lua-language-server.tar.gz -C /usr/local/share/lua-language-server
rm /tmp/lua-language-server.tar.gz

ln -sf /usr/local/share/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server
