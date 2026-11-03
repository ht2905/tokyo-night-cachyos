#!/usr/bin/env bash
# ==============================================================================
# 🧹 TOKYO NIGHT BACKUP & ROLLBACK UTILITY 🧹
# ------------------------------------------------------------------------------
# 1. Option 1: Finalize & Clean (Keep Tokyo Night active, delete backup folder)
# 2. Option 2: Full Rollback (Restore all original tool configs, revert changes, delete backups)
# 3. Option 3: Delete backups only
# ==============================================================================

set -e

# --- ANSI Palette ---
C_RESET="\033[0m"
C_BOLD="\033[1m"
C_INDIGO="\033[38;5;68m"
C_CYAN="\033[38;5;117m"
C_PURPLE="\033[38;5;141m"
C_MINT="\033[38;5;150m"
C_AMBER="\033[38;5;215m"

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

# Locate backups
shopt -s nullglob
BACKUP_DIRS=("$HOME"/.tokyo_night_backup_*)
shopt -u nullglob

if [[ ${#BACKUP_DIRS[@]} -eq 0 ]]; then
  echo ""
  log_warn "No backup directories found matching ~/.tokyo_night_backup_*"
  echo -e "Your setup is already clean or backups were previously removed."
  echo ""
  exit 0
fi

LATEST_BACKUP=$(ls -td "$HOME"/.tokyo_night_backup_* 2>/dev/null | head -n 1)

print_menu() {
  echo -e "${C_INDIGO}"
  echo "  ╭─────────────────────────────────────────────────────────────╮"
  echo "  │        🧹  TOKYO NIGHT BACKUP & ROLLBACK UTILITY  🧹        │"
  echo "  ╰─────────────────────────────────────────────────────────────╯"
  echo -e "${C_RESET}"
  echo -e "Found latest backup: ${C_CYAN}$LATEST_BACKUP${C_RESET}"
  echo ""
  echo -e "${C_BOLD}Please select an action:${C_RESET}"
  echo -e "  ${C_CYAN}[1]${C_RESET} ${C_BOLD}Finalize & Clean${C_RESET} (Keep Tokyo Night active across all tools, delete backup folders)"
  echo -e "  ${C_CYAN}[2]${C_RESET} ${C_BOLD}Full Rollback / Restore${C_RESET} (Restore original files, revert Bat, Micro, Konsole, and Zsh)"
  echo -e "  ${C_CYAN}[3]${C_RESET} ${C_BOLD}Delete Backups Only${C_RESET} (Keep current setup as-is, simply remove backup files)"
  echo -e "  ${C_CYAN}[4]${C_RESET} Cancel"
  echo ""
}

# --- Action 1: Finalize & Clean ---
action_finalize() {
  log_step "Finalizing Tokyo Night setup and removing backup files..."
  for bdir in "${BACKUP_DIRS[@]}"; do
    rm -rf "$bdir"
    log_success "Removed $bdir"
  done
  echo ""
  echo -e "${C_MINT}✨ Tokyo Night suite finalized and backup files cleaned up!${C_RESET}"
  echo ""
}

# --- Action 2: Full Rollback ---
action_rollback() {
  log_step "Reverting all changes and restoring original configurations..."

  # 1. Restore .p10k.zsh and .zshrc
  if [[ -f "$LATEST_BACKUP/.p10k.zsh" ]]; then
    cp "$LATEST_BACKUP/.p10k.zsh" "$HOME/.p10k.zsh"
    log_sub "Restored original ~/.p10k.zsh"
  fi

  if [[ -f "$LATEST_BACKUP/.zshrc" ]]; then
    cp "$LATEST_BACKUP/.zshrc" "$HOME/.zshrc"
    log_sub "Restored original ~/.zshrc"
  fi

  # 2. Revert Micro
  if [[ -d "$LATEST_BACKUP/micro" ]]; then
    rm -rf "$HOME/.config/micro"
    mkdir -p "$HOME/.config/micro"
    cp -r "$LATEST_BACKUP/micro"/* "$HOME/.config/micro/" 2>/dev/null || true
    log_sub "Restored ~/.config/micro"
  else
    rm -f "$HOME/.config/micro/colorschemes/tokyonight.micro"
  fi

  # 3. Revert Bat
  if [[ -d "$LATEST_BACKUP/bat" ]]; then
    rm -rf "$HOME/.config/bat"
    mkdir -p "$HOME/.config/bat"
    cp -r "$LATEST_BACKUP/bat"/* "$HOME/.config/bat/" 2>/dev/null || true
    log_sub "Restored ~/.config/bat"
  fi
  if command -v bat &>/dev/null; then
    bat cache --build &>/dev/null || true
    log_sub "Rebuilt bat cache"
  fi

  # 4. Revert Fastfetch
  if [[ -d "$LATEST_BACKUP/fastfetch" ]]; then
    rm -rf "$HOME/.config/fastfetch"
    mkdir -p "$HOME/.config/fastfetch"
    cp -r "$LATEST_BACKUP/fastfetch"/* "$HOME/.config/fastfetch/" 2>/dev/null || true
    log_sub "Restored ~/.config/fastfetch"
  fi

  # 5. Clean up Konsole Tokyo Night files
  rm -f "$HOME/.local/share/konsole/TokyoNight.colorscheme"
  rm -f "$HOME/.local/share/konsole/TokyoNightStorm.colorscheme"
  rm -f "$HOME/.local/share/konsole/TokyoNight.profile"
  log_sub "Removed Tokyo Night profiles from Konsole"

  # 6. Remove environment integration
  rm -f "$HOME/.config/zsh/tokyo-night-env.zsh"

  # 7. Delete backup directory
  for bdir in "${BACKUP_DIRS[@]}"; do
    rm -rf "$bdir"
    log_success "Removed $bdir"
  done

  echo ""
  echo -e "${C_MINT}🔄 Rollback complete! Original configurations restored and backups removed.${C_RESET}"
  echo -e "Run ${C_CYAN}exec zsh${C_RESET} to reload your original shell."
  echo ""
}

# --- Action 3: Delete Backups Only ---
action_delete_only() {
  log_step "Deleting backup directories..."
  for bdir in "${BACKUP_DIRS[@]}"; do
    rm -rf "$bdir"
    log_success "Removed $bdir"
  done
  echo -e "${C_MINT}✨ Backup folders removed.${C_RESET}"
}

CHOICE="$1"
if [[ -z "$CHOICE" ]]; then
  print_menu
  read -r -p "Enter choice [1-4]: " USER_INPUT
  CHOICE="$USER_INPUT"
fi

case "$CHOICE" in
  1|--finalize|-f)
    action_finalize
    ;;
  2|--rollback|--restore|-r)
    action_rollback
    ;;
  3|--delete-only|-d)
    action_delete_only
    ;;
  4|cancel|q)
    echo "Cancelled. No files modified."
    exit 0
    ;;
  *)
    log_warn "Invalid option '$CHOICE'. Usage: ./cleanup.sh [--finalize | --rollback | --delete-only]"
    exit 1
    ;;
esac
