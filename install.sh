#!/usr/bin/env bash
# ==============================================================================
# 🌃 ALL-IN-ONE TOKYO NIGHT SUITE FOR CACHYOS / KONSOLE 🌃
# ------------------------------------------------------------------------------
# 1. Backs up existing Konsole, Micro, Bat, Fastfetch, and Zsh configs
# 2. Installs Tokyo Night & Tokyo Night Storm for KDE Konsole
# 3. Configures Micro editor with Tokyo Night palette
# 4. Configures Bat with tokyonight_night TextMate theme & rebuilds cache
# 5. Configures Fastfetch with Tokyo Night colors & CachyOS specs
# 6. Deploys Tokyo Night Powerlevel10k theme (~/.p10k.zsh)
# 7. Injects Tokyo Night FZF, Autosuggestions & Syntax Highlighting
# ==============================================================================

set -e

# --- Tokyo Night ANSI Palette for Installer Output ---
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_INDIGO="\033[38;5;68m"
C_CYAN="\033[38;5;117m"
C_PURPLE="\033[38;5;141m"
C_MINT="\033[38;5;150m"
C_AMBER="\033[38;5;215m"
C_MUTED="\033[38;5;60m"

print_banner() {
  echo -e "${C_INDIGO}"
  echo "  ╭─────────────────────────────────────────────────────────────╮"
  echo "  │        🌃 ✨  TOKYO NIGHT SUITE FOR CACHYOS  ✨ 🌃          │"
  echo "  │         Konsole + Powerlevel10k + Bat + Micro + FZF         │"
  echo "  ╰─────────────────────────────────────────────────────────────╯"
  echo -e "${C_RESET}"
}

log_step() {
  echo -e "${C_CYAN}==>${C_RESET} ${C_BOLD}${C_PURPLE}$1${C_RESET}"
}

log_sub() {
  echo -e "   ${C_INDIGO}󰅂 $1${C_RESET}"
}

log_success() {
  echo -e "   ${C_MINT}✨ $1${C_RESET}"
}

log_warn() {
  echo -e "   ${C_AMBER}⚠️  $1${C_RESET}"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$HOME/.tokyo_night_backup_${TIMESTAMP}"

print_banner

# ==============================================================================
# STEP 1: SAFETY BACKUP OF MODIFIED CONFIGS
# ==============================================================================
log_step "Step 1/6: Creating safety backup of your existing configs..."

mkdir -p "$BACKUP_DIR"

# Backup shell files
for f in ".zshrc" ".p10k.zsh"; do
  if [[ -f "$HOME/$f" ]]; then
    cp "$HOME/$f" "$BACKUP_DIR/"
    log_sub "Backed up ~/$f"
  fi
done

# Backup tool configs if present
if [[ -d "$HOME/.config/micro" ]]; then
  mkdir -p "$BACKUP_DIR/micro"
  cp -r "$HOME/.config/micro"/* "$BACKUP_DIR/micro/" 2>/dev/null || true
  log_sub "Backed up ~/.config/micro"
fi

if [[ -d "$HOME/.config/bat" ]]; then
  mkdir -p "$BACKUP_DIR/bat"
  cp -r "$HOME/.config/bat"/* "$BACKUP_DIR/bat/" 2>/dev/null || true
  log_sub "Backed up ~/.config/bat"
fi

if [[ -d "$HOME/.config/fastfetch" ]]; then
  mkdir -p "$BACKUP_DIR/fastfetch"
  cp -r "$HOME/.config/fastfetch"/* "$BACKUP_DIR/fastfetch/" 2>/dev/null || true
  log_sub "Backed up ~/.config/fastfetch"
fi

log_success "All current settings safely preserved in $BACKUP_DIR"

# ==============================================================================
# STEP 2: INSTALL KDE KONSOLE COLOR SCHEMES & PROFILE
# ==============================================================================
log_step "Step 2/6: Installing Tokyo Night for KDE Konsole..."

KONSOLE_DIR="$HOME/.local/share/konsole"
mkdir -p "$KONSOLE_DIR"

cp "$SCRIPT_DIR/TokyoNight.colorscheme" "$KONSOLE_DIR/"
cp "$SCRIPT_DIR/TokyoNightStorm.colorscheme" "$KONSOLE_DIR/"
log_sub "Copied TokyoNight.colorscheme and TokyoNightStorm.colorscheme to $KONSOLE_DIR"

# Create a dedicated Konsole profile: Tokyo Night
PROFILE_FILE="$KONSOLE_DIR/TokyoNight.profile"
cat << 'EOF' > "$PROFILE_FILE"
[General]
Name=Tokyo Night
Parent=FALLBACK/

[Appearance]
ColorScheme=TokyoNight
Font=MesloLGS NF,11,-1,5,50,0,0,0,0,0

[Scrolling]
HistoryMode=2
ScrollBarPosition=2
EOF
log_sub "Created Konsole profile: $PROFILE_FILE"
log_success "Konsole themes & profile ready!"

# ==============================================================================
# STEP 3: CONFIGURE MICRO EDITOR
# ==============================================================================
log_step "Step 3/6: Configuring Micro editor with Tokyo Night..."

MICRO_DIR="$HOME/.config/micro"
MICRO_SCHEMES="$MICRO_DIR/colorschemes"
mkdir -p "$MICRO_SCHEMES"

cp "$SCRIPT_DIR/tokyonight.micro" "$MICRO_SCHEMES/"
log_sub "Installed tokyonight.micro in $MICRO_SCHEMES"

# Safely update settings.json using Python
python3 - << 'EOF'
import json, os

settings_path = os.path.expanduser("~/.config/micro/settings.json")
data = {}
if os.path.exists(settings_path):
    try:
        with open(settings_path, "r") as f:
            data = json.load(f)
    except Exception:
        data = {}

data["colorscheme"] = "tokyonight"

with open(settings_path, "w") as f:
    json.dump(data, f, indent=4)
EOF
log_success "Micro editor set to tokyonight colorscheme!"

# ==============================================================================
# STEP 4: CONFIGURE BAT (PAGER) & REBUILD CACHE
# ==============================================================================
log_step "Step 4/6: Configuring Bat pager with Tokyo Night..."

if command -v bat &>/dev/null; then
  BAT_CONFIG_DIR="$(bat --config-dir 2>/dev/null || echo "$HOME/.config/bat")"
  BAT_THEMES_DIR="$BAT_CONFIG_DIR/themes"
  mkdir -p "$BAT_THEMES_DIR"

  cp "$SCRIPT_DIR/tokyonight_night.tmTheme" "$BAT_THEMES_DIR/"
  log_sub "Rebuilding bat theme cache..."
  bat cache --build &>/dev/null || true

  # Ensure config sets tokyonight_night
  mkdir -p "$BAT_CONFIG_DIR"
  if [[ -f "$BAT_CONFIG_DIR/config" ]]; then
    if ! grep -q 'tokyonight_night' "$BAT_CONFIG_DIR/config"; then
      echo '--theme="tokyonight_night"' >> "$BAT_CONFIG_DIR/config"
    fi
  else
    echo '--theme="tokyonight_night"' > "$BAT_CONFIG_DIR/config"
  fi
  log_success "Bat configured with tokyonight_night theme!"
else
  log_warn "bat command not found, skipping bat theme build."
fi

# ==============================================================================
# STEP 5: CONFIGURE FASTFETCH
# ==============================================================================
log_step "Step 5/6: Configuring Fastfetch..."

FASTFETCH_DIR="$HOME/.config/fastfetch"
mkdir -p "$FASTFETCH_DIR"
cp "$SCRIPT_DIR/fastfetch.jsonc" "$FASTFETCH_DIR/config.jsonc"
log_success "Fastfetch config installed into ~/.config/fastfetch/config.jsonc"

# ==============================================================================
# STEP 6: POWERLEVEL10K & ZSH ENVIRONMENT INTEGRATION
# ==============================================================================
log_step "Step 6/6: Deploying Tokyo Night Powerlevel10k & Zsh integration..."

# 1. Deploy tokyo-night.p10k.zsh
cp "$SCRIPT_DIR/tokyo-night.p10k.zsh" "$HOME/.p10k.zsh"
log_sub "Deployed Tokyo Night theme to ~/.p10k.zsh"

# 2. Deploy environment integration (FZF, Autosuggestions, Syntax Highlighting)
ZSH_CONF_DIR="$HOME/.config/zsh"
mkdir -p "$ZSH_CONF_DIR"
cp "$SCRIPT_DIR/tokyo-night-env.zsh" "$ZSH_CONF_DIR/"

# Wire into ~/.zshrc if not already sourced
if [[ -f "$HOME/.zshrc" ]]; then
  if ! grep -q "tokyo-night-env.zsh" "$HOME/.zshrc"; then
    cat << 'EOF' >> "$HOME/.zshrc"

# === TOKYO NIGHT SUITE INTEGRATION ===
[[ -f ~/.config/zsh/tokyo-night-env.zsh ]] && source ~/.config/zsh/tokyo-night-env.zsh
EOF
    log_sub "Appended Tokyo Night environment sourcing to ~/.zshrc"
  fi
fi

log_success "Zsh environment & Powerlevel10k configured!"

echo ""
echo -e "${C_INDIGO}═════════════════════════════════════════════════════════════════${C_RESET}"
echo -e "${C_BOLD}${C_CYAN}  🎉 ALL DONE! TOKYO NIGHT SUITE INSTALLED ON CACHYOS! 🌃${C_RESET}"
echo -e "${C_PURPLE}  1. A full safety backup was saved to:${C_RESET} ${C_MUTED}$BACKUP_DIR${C_RESET}"
echo -e "${C_PURPLE}  2. Konsole theme 'Tokyo Night' installed (~/.local/share/konsole)${C_RESET}"
echo -e "${C_PURPLE}  3. Micro editor colorscheme set to 'tokyonight'${C_RESET}"
echo -e "${C_PURPLE}  4. Bat cache built with 'tokyonight_night' theme${C_RESET}"
echo -e "${C_PURPLE}  5. Powerlevel10k configured with Tokyo Night palette${C_RESET}"
echo -e "${C_PURPLE}  6. Fastfetch tuned with Tokyo Night cyber colors${C_RESET}"
echo -e "${C_INDIGO}═════════════════════════════════════════════════════════════════${C_RESET}"
echo ""
echo -e "${C_BOLD}Next Step for Konsole:${C_RESET}"
echo -e "  In Konsole: Open ${C_CYAN}Settings${C_RESET} > ${C_CYAN}Manage Profiles...${C_RESET} > Select ${C_CYAN}Tokyo Night${C_RESET} > Click ${C_CYAN}Set as Default${C_RESET}."
echo ""
echo -e "To reload your shell right now: ${C_CYAN}exec zsh${C_RESET}"
echo ""
