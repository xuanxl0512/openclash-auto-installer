#!/bin/sh
set -eu

# Legacy compatibility entrypoint.
# The old test downloader was opkg-only and duplicated PassWall download logic.
# Keep this filename working by delegating to the maintained PassWall installer.

REPO="slobys/openclash-auto-installer"
BRANCH="main"
TMP_SCRIPT="/tmp/passwall-installer-test.sh"

log() {
    printf '%s\n' "==> $*"
}

die() {
    printf '%s\n' "[ERROR] $*" >&2
    exit 1
}

if [ -f "./passwall.sh" ]; then
    log "test-auto-download.sh 已合并到 passwall.sh，转交给本地 passwall.sh"
    exec sh ./passwall.sh "$@"
fi

command -v curl >/dev/null 2>&1 || die "缺少 curl 命令，无法下载 passwall.sh"
log "test-auto-download.sh 已合并到 passwall.sh，下载最新 passwall.sh"
curl -fsSL --retry 3 "https://raw.githubusercontent.com/$REPO/$BRANCH/passwall.sh" -o "$TMP_SCRIPT" || die "下载 passwall.sh 失败"
exec sh "$TMP_SCRIPT" "$@"
