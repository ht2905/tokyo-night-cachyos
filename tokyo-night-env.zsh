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

# ==============================================================================
# 🌙 TOKYO NIGHT OPENING GREETING SEQUENCE 🌙
# 1. Fastfetch system overview
# 2. Dynamic Time-of-Day Neon Greeting + Matching Duo Cat
# 3. Attributed Wisdom & Science Quote Box
# ==============================================================================
if [[ -o interactive ]]; then
  # 1. Fastfetch Overview
  if command -v fastfetch &>/dev/null; then
    fastfetch --pipe false
  fi

  # 2. Dynamic Time-of-Day Neon Greeting + Matching Duo Cat
  local hour=$(date +%-H)
  local icon mood_face greeting subline
  local current_user="${USER:-$(whoami)}"

  if (( hour >= 5 && hour < 12 )); then
    icon="🌅 "
    mood_face="( •̀_•́ )"
    greeting="Good morning, ${current_user}! Fresh brew poured, let's make today count ☕"
    subline="Systems primed & ready for high-impact focus ⚡"
  elif (( hour >= 12 && hour < 18 )); then
    icon="☀️ "
    mood_face="( •̀_•́ )"
    greeting="Good afternoon, ${current_user}! Deep work session in full swing 🚀"
    subline="CachyOS running peak performance. Stay in the zone! 🔥"
  elif (( hour >= 18 && hour < 23 )); then
    icon="🌙 "
    mood_face="( -.- )"
    greeting="Good evening, ${current_user}! Tokyo Night neon vibes activated ✨"
    subline="Smooth late-night coding session. Don't forget to hydrate 🍵"
  else
    icon="🌌 "
    mood_face="( ˘ω˘ )"
    greeting="Burning the midnight oil? Tokyo Night quiet hours 🌃"
    subline="Hack the impossible, but remember rest fuels genius 💤"
  fi

  local C_PURPLE="\033[38;5;141m"
  local C_CYAN="\033[38;5;117m"
  local C_BLUE="\033[38;5;75m"
  local C_MINT="\033[38;5;158m"
  local C_SLATE="\033[38;5;103m"
  local C_RESET="\033[0m"

  echo ""
  echo -e "${C_PURPLE}   /\\_/\\  ${C_CYAN} ${icon}${greeting}${C_RESET}"
  echo -e "${C_PURPLE}  ${mood_face} ${C_BLUE} ${subline}${C_RESET}"
  echo -e "${C_PURPLE}   > ^ <  ${C_MINT} Terminal ready. Let's do great work! 💫${C_RESET}"
  echo ""

  # 3. Randomized Wisdom & Science Quotes (Attributed & Authenticated)
  local quotes=(
    "Discovery consists of seeing what everybody has seen, and thinking what nobody has thought. — Albert Szent-Györgyi"
    "We are drowning in a sea of data and starving for knowledge. — Sydney Brenner"
    "Science and everyday life cannot and should not be separated. — Rosalind Franklin"
    "In the fields of observation, chance favors only the prepared mind. — Louis Pasteur"
    "Nothing in life is to be feared, it is only to be understood. — Marie Curie"
    "We used to think our fate was in our stars. Now we know our fate is in our genes. — James Watson"
    "Simplicity is prerequisite for reliability. — Edsger W. Dijkstra"
    "Make it work, make it right, make it fast. — Kent Beck"
    "Premature optimization is the root of all evil. — Donald Knuth"
    "Talk is cheap. Show me the code. — Linus Torvalds"
    "Debugging is twice as hard as writing the code in the first place. — Brian Kernighan"
    "The best way to predict the future is to invent it. — Alan Kay"
    "Good judgment comes from experience, and experience comes from bad judgment. — Fred Brooks"
    "We can only see a short distance ahead, but plenty there needs to be done. — Alan Turing"
    "Information is the resolution of uncertainty. — Claude Shannon"
    "What I cannot create, I do not understand. — Richard Feynman"
    "The important thing is not to stop questioning. — Albert Einstein"
    "Imagination is the discovering faculty, pre-eminently. — Ada Lovelace"
    "First, solve the problem. Then, write the code. — John Johnson"
    "Out of clutter find simplicity; from discord find harmony. — John Archibald Wheeler"
  )

  local rand_idx=$(( RANDOM % ${#quotes[@]} + 1 ))
  local quote="${quotes[$rand_idx]}"

  local inner_width=76
  local quote_str="\"$quote\""
  (( ${#quote_str} + 2 > inner_width )) && inner_width=$(( ${#quote_str} + 2 ))

  local pad_len=$(( inner_width - ${#quote_str} ))
  local pad=$(printf "%*s" "$pad_len" "")
  local border="${(l:inner_width::─:)}"

  local header_text="󰄛 TOKYO NIGHT STATION │ CachyOS Linux │ Bio & Core Workspace"
  local h_pad_len=$(( inner_width - ${#header_text} ))
  local h_pad=$(printf "%*s" "$h_pad_len" "")

  echo -e "${C_SLATE}  ╭${border}╮"
  echo -e "  │ \033[38;5;141m󰄛 \033[38;5;75mTOKYO NIGHT STATION \033[38;5;103m│ \033[38;5;158mCachyOS Linux \033[38;5;103m│ \033[38;5;117mBio & Core Workspace${h_pad:1}${C_SLATE}│"
  echo -e "  │ ${C_CYAN}${quote_str}${pad:1}${C_SLATE}│"
  echo -e "  ╰${border}╯${C_RESET}"
  echo ""
fi
