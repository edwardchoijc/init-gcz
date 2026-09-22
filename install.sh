#!/usr/bin/env bash
# init-gcz one-click installer.
# Sets up commitlint + husky + commitizen in the current git repo, with
# commit-and-tag-version available for releases.
# Usage: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/edwardchoijc/init-gcz/HEAD/install.sh)"

set -euo pipefail

# Configuration (overridable via environment variables).
REPO_URL="${INIT_GCZ_REPO:-https://github.com/edwardchoijc/init-gcz.git}"
TARGET_DIR="$(pwd)"

# Clone into a throwaway directory and remove it on exit, so the installer
# leaves nothing behind but the files it copies into the project.
SRC_DIR="$(mktemp -d "${TMPDIR:-/tmp}/init-gcz.XXXXXX")"
cleanup() { rm -rf "$SRC_DIR"; }
trap cleanup EXIT

# Logging helpers: colored when writing to a terminal, plain otherwise.
if [ -t 1 ]; then
  C_RESET=$'\033[0m'; C_INFO=$'\033[34m'; C_OK=$'\033[32m'; C_WARN=$'\033[33m'; C_ERR=$'\033[31m'
else
  C_RESET=""; C_INFO=""; C_OK=""; C_WARN=""; C_ERR=""
fi
info() { printf '%s==>%s %s\n' "$C_INFO" "$C_RESET" "$*"; }
ok()   { printf '    %s✓%s %s\n' "$C_OK" "$C_RESET" "$*"; }
warn() { printf '    %s!%s %s\n' "$C_WARN" "$C_RESET" "$*" >&2; }
die()  { printf '%sError:%s %s\n' "$C_ERR" "$C_RESET" "$*" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

# Copy a single file from the source repo into the target, backing up any
# existing copy and staying silent when the content is already up to date.
sync_file() {
  local rel="$1"
  local src="$SRC_DIR/$rel"
  local dst="$TARGET_DIR/$rel"
  [ -f "$src" ] || die "missing $rel in source repo ($SRC_DIR)"
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
    return
  fi
  if [ -f "$dst" ]; then
    cp "$dst" "$dst.init-gcz.bak.$(date +%Y%m%d%H%M%S)"
    warn "backed up existing $rel"
  fi
  cp "$src" "$dst"
  ok "installed $rel"
}

# Merge the source .gitignore into the target, adding only real ignore patterns
# (skipping blank lines and comments) that are not already present.
merge_gitignore() {
  local src="$SRC_DIR/.gitignore"
  local dst="$TARGET_DIR/.gitignore"
  [ -f "$src" ] || return
  touch "$dst"
  local added=0 entry
  while IFS= read -r entry || [ -n "$entry" ]; do
    case "$entry" in
      ''|'#'*) continue ;;  # skip blank lines and comments
    esac
    if ! grep -qxF "$entry" "$dst"; then
      printf '%s\n' "$entry" >>"$dst"
      added=$((added + 1))
    fi
  done <"$src"
  [ "$added" -gt 0 ] && ok "added $added entr$([ "$added" -eq 1 ] && echo y || echo ies) to .gitignore"
  return 0
}

# Verify prerequisites.
for cmd in git npm; do
  have "$cmd" || die "$cmd is required but not installed."
done
git -C "$TARGET_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || die "current directory is not a git repository; run 'git init' in your project root first."

# Clone the source repo into the temp directory.
info "fetching init-gcz"
git clone --quiet --depth 1 "$REPO_URL" "$SRC_DIR"

# Copy config files into the target project.
info "copying config files into $TARGET_DIR"
sync_file "package.json"
sync_file "commitlint.config.js"
# Copy husky hooks, preserving husky's generated _/ directory.
while IFS= read -r hook; do
  sync_file ".husky/${hook#"$SRC_DIR/.husky/"}"
done < <(find "$SRC_DIR/.husky" -type f ! -path "*/_/*")
merge_gitignore

# Install dependencies and enable husky hooks.
info "installing dependencies (npm install)"
( cd "$TARGET_DIR" && npm install )
info "enabling husky hooks (npm run prepare)"
( cd "$TARGET_DIR" && npm run prepare )

info "done — commitlint + husky are ready in $TARGET_DIR"
info "run 'npm run commit' to write a commit message interactively (commitizen)"
info "run 'npm run release' to cut a release (bump version, update CHANGELOG, tag)"
