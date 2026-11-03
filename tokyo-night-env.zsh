# ==============================================================================
# 🌃 TOKYO NIGHT ENVIRONMENT & CLI INTEGRATION 🌃
# Sourced in ~/.zshrc for FZF, bat, micro, autosuggestions & syntax highlighting
# ==============================================================================

# --- FZF Tokyo Night Color Palette ---
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7 \
  --color=fg+:#c0caf5,bg+:#24283b,hl+:#7dcfff \
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff \
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"

# --- Zsh Autosuggestions (Discreet Tokyo Night Slate Blue) ---
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'

# --- Bat Tokyo Night Theme ---
export BAT_THEME="tokyonight_night"

# --- Zsh Syntax Highlighting (Tokyo Night Palette) ---
if typeset -p ZSH_HIGHLIGHT_STYLES &>/dev/null; then
  ZSH_HIGHLIGHT_STYLES[command]='fg=117,bold'            # Cyan
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=68,bold'             # Indigo
  ZSH_HIGHLIGHT_STYLES[alias]='fg=141,bold'              # Purple
  ZSH_HIGHLIGHT_STYLES[function]='fg=150,bold'           # Mint
  ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=215'    # Amber
  ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=215'
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=150'  # Green
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=150'
  ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=141'
  ZSH_HIGHLIGHT_STYLES[path]='fg=68,underline'
  ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=203,bold'      # Red
fi
