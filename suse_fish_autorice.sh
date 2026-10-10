#!/usr/bin/env bash
set -euo pipefail

echo "[1/8] Installing base packages…"
sudo zypper refresh
sudo zypper install -y fish git stow fzf ripgrep fd bat zoxide curl unzip wget tar fastfetch

echo "[2/8] Installing eza/exa…"
sudo zypper install -y eza || sudo zypper install -y exa || true

echo "[3/8] Installing Starship prompt…"
if ! command -v starship >/dev/null 2>&1; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

echo "[4/8] Cloning/Updating your dotfiles…"
DF_DIR="$HOME/dotfiles"
if [ -d "$DF_DIR/.git" ]; then
  git -C "$DF_DIR" pull --ff-only
else
  git clone --depth=1 https://github.com/Jin9zi/dotfiles.git "$DF_DIR"
fi

echo "[5/8] Stowing .config…"
mkdir -p "$HOME/.config"

for item in fish starship.toml; do
  if [ -e "$HOME/.config/$item" ] && [ ! -L "$HOME/.config/$item" ]; then
    mv "$HOME/.config/$item" "$HOME/.config/${item}.bak.$(date +%s)"
    echo "  backed up ~/.config/$item"
  fi
done

cd "$DF_DIR"
stow -v --target="$HOME/.config" .config
ln -sf "$HOME/dotfiles/.config/starship.toml" "$HOME/.config/starship.toml"

CFG="$HOME/.config/fish/config.fish"
mkdir -p "$(dirname "$CFG")"
touch "$CFG"

grep -q 'fish_add_path .*\.cargo/bin' "$CFG" 2>/dev/null || \
  echo 'fish_add_path $HOME/.cargo/bin' >> "$CFG"

grep -q 'starship init fish' "$CFG" 2>/dev/null || \
  echo 'status is-interactive; and starship init fish | source' >> "$CFG"

grep -q 'zoxide init fish' "$CFG" 2>/dev/null || \
  echo 'status is-interactive; and zoxide init fish | source' >> "$CFG"

echo "[6/8] Installing Fisher + plugins…"
if ! fish -c 'functions -q fisher' >/dev/null 2>&1; then
  fish -c 'curl -sL https://git.io/fisher | source; fisher install jorgebucaran/fisher'
fi

fish -c 'fisher install PatrickF1/fzf.fish' || true

echo "[7/8] Installing JetBrainsMono Nerd Font locally…"
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"

if [ ! -f "$FONT_DIR/JetBrains Mono Regular Nerd Font Complete.ttf" ] && \
   [ ! -d "$FONT_DIR/JetBrainsMonoNerdFont" ]; then
  wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O JetBrainsMono.zip
  unzip -o JetBrainsMono.zip >/dev/null
  rm -f JetBrainsMono.zip
  fc-cache -f
fi

echo "[8/8] Setting fish as default shell…"
if [ "$SHELL" != "$(command -v fish)" ]; then
  chsh -s "$(command -v fish)" || true
fi

echo "✅ All done! Close & reopen your terminal, or run: exec fish"
echo "In Konsole: Settings → Edit Profile → Font → JetBrainsMono Nerd Font"
