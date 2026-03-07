#!/usr/bin/env bash
# install_homebrew.sh - Installs Homebrew and configures shell environment

set -e

# ── Detect shell config file ──────────────────────────────────────────────────
if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
  SHELL_RC="$HOME/.zshrc"
else
  SHELL_RC="$HOME/.bashrc"
fi

echo "→ Using shell config: $SHELL_RC"

# ── Install Homebrew ──────────────────────────────────────────────────────────
echo "→ Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# ── Detect Homebrew prefix (Intel Mac / Apple Silicon / Linux) ────────────────
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  BREW_PREFIX="/home/linuxbrew/.linuxbrew"
elif [ -d "/opt/homebrew" ]; then
  BREW_PREFIX="/opt/homebrew"
elif [ -d "/usr/local" ] && [ -f "/usr/local/bin/brew" ]; then
  BREW_PREFIX="/usr/local"
else
  echo "✗ Could not detect Homebrew prefix. Please add it manually."
  exit 1
fi

echo "→ Homebrew prefix: $BREW_PREFIX"

# ── Add shellenv to rc file if not already present ───────────────────────────
BREW_SHELLENV="eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\""

if grep -qF "$BREW_SHELLENV" "$SHELL_RC" 2>/dev/null; then
  echo "→ Shell config already contains Homebrew env — skipping."
else
  echo "" >> "$SHELL_RC"
  echo "# Homebrew" >> "$SHELL_RC"
  echo "$BREW_SHELLENV" >> "$SHELL_RC"
  echo "→ Added Homebrew env to $SHELL_RC"
fi

# ── Apply to current session ──────────────────────────────────────────────────
eval "$("${BREW_PREFIX}/bin/brew" shellenv)"

echo ""
echo "✓ Homebrew installed: $(brew --version)"
echo "✓ Restart your terminal or run:  source $SHELL_RC"
