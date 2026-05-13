#!/bin/sh
set -eu

# Legacy compatibility entrypoint.
# The old implementation was a hard-coded OpenWrt 24.10/aarch64/opkg PassWall helper.
# Keep this filename working by delegating to the maintained PassWall installer,
# which now supports both opkg and OpenWrt 25.12+ apk environments.

REPO="slobys/openclash-auto-installer"
BRANCH="main"
TMP_SCRIPT="/tmp/passwall-installer.sh"

log() {
    printf '%s\n' "==> $*"
}

die() {
    printf '%s\n' "[ERROR] $*" >&2
    exit 1
}

if [ -f "./passwall.sh" ]; then
    log "auto-download-pro.sh 已合并到 passwall.sh，转交给本地 passwall.sh"
    exec sh ./passwall.sh "$@"
fi

command -v curl >/dev/null 2>&1 || die "缺少 curl 命令，无法下载 passwall.sh"
log "auto-download-pro.sh 已合并到 passwall.sh，下载最新 passwall.sh"
curl -fsSL --retry 3 "https://raw.githubusercontent.com/$REPO/$BRANCH/passwall.sh" -o "$TMP_SCRIPT" || die "下载 passwall.sh 失败"
exec sh "$TMP_SCRIPT" "$@"
