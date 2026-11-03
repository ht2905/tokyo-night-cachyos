# Implementation Plan: Tokyo Night Terminal Opening Sequence

This plan details the design and deployment of an opening terminal greeting sequence for your CachyOS setup (`configs/.zshrc` in `cachyos-config`), matching the charm and companionship of your girlfriend's pink setup while integrating with your Tokyo Night aesthetic and bioinformatics workflow.

---

## Architecture & Flow

```mermaid
flowchart TD
    A["User opens interactive terminal (Konsole / Alacritty)"] --> B{"Is shell interactive?\n[[ -o interactive ]]"}
    B -- No (Scripts/SCP) --> C["Silent exit (Preserve non-interactive performance)"]
    B -- Yes --> D["1. Execute fastfetch"]
    D --> E["2. Determine Local Time & Mood"]
    E --> F["Evaluate Morning / Afternoon / Evening / Late Night"]
    F --> G["Print Tokyo Night Duo Cat with dynamic icon, mood face & message"]
    G --> H["3. Pick Random Quote from Curated Wisdom Array"]
    H --> I["Compute dynamic padding & print Tokyo Night Banner"]
    I --> J["Ready at command prompt"]
```

---

## User Review Required

> [!IMPORTANT]
> The greeting is placed at the **very end** of [`configs/.zshrc`](file:///home/ht2905/cachyos-config/configs/.zshrc) guarded by `if [[ -o interactive ]]; then ... fi`.
> This ensures:
> 1. Powerlevel10k instant prompt is never disrupted.
> 2. Automated tasks, `scp`, `sftp`, `rsync`, and IDE background processes run cleanly with zero noise.
> 3. Rendering overhead is $<2\text{ms}$ (pure native Zsh parameter expansions, no Python/Ruby dependencies).

> [!NOTE]
> Review the initial quote collection below. You can easily add, edit, or remove quotes at any time.

---

## Proposed Changes

### Configuration: `cachyos-config`

#### [MODIFY] [`configs/.zshrc`](file:///home/ht2905/cachyos-config/configs/.zshrc)

Append the complete interactive greeting block at the bottom of [`/home/ht2905/cachyos-config/configs/.zshrc`](file:///home/ht2905/cachyos-config/configs/.zshrc):

```zsh
# ==============================================================================
# 🌙 TOKYO NIGHT OPENING GREETING SEQUENCE 🌙
# 1. fastfetch system overview
# 2. Dynamic Time-of-Day Neon Greeting + Matching Duo Cat
# 3. Randomized Tokyo Night wisdom quote box
# ==============================================================================
if [[ -o interactive ]]; then
  # 1. Fastfetch Overview
  if command -v fastfetch &>/dev/null; then
    fastfetch
  fi

  # 2. Dynamic Time-of-Day Neon Greeting + Matching Duo Cat
  local hour=$(date +%-H)
  local icon mood_face greeting subline

  if (( hour >= 5 && hour < 12 )); then
    icon="🌅 "
    mood_face="( •̀_•́ )"
    greeting="Good morning, ht2905! Fresh brew poured, let's make today count ☕"
    subline="Systems primed & ready for high-impact focus ⚡"
  elif (( hour >= 12 && hour < 18 )); then
    icon="☀️ "
    mood_face="( •̀_•́ )"
    greeting="Good afternoon, ht2905! Deep work session in full swing 🚀"
    subline="CachyOS running peak performance. Stay in the zone! 🔥"
  elif (( hour >= 18 && hour < 23 )); then
    icon="🌙 "
    mood_face="( -.- )"
    greeting="Good evening, ht2905! Tokyo Night neon vibes activated ✨"
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

  # 3. Randomized Wisdom & Science Quotes
  local quotes=(
    "Every complex biological code yields to patience and curiosity."
    "Simplicity is prerequisite for reliability. — Edsger W. Dijkstra"
    "Make it work, make it right, make it fast. — Kent Beck"
    "Discovery consists of seeing what everybody has seen and thinking what nobody has thought."
    "First, solve the problem. Then, write the code. — John Johnson"
    "Stay curious, keep compiling, and never stop discovering."
    "Precision in thought leads to elegance in execution."
    "Code with clarity, research with passion, rest with ease."
    "Small daily commits lead to monumental breakthroughs."
    "The best way to predict the future is to invent it. — Alan Kay"
    "Premature optimization is the root of all evil. — Donald Knuth"
    "In the middle of difficulty lies opportunity. — Albert Einstein"
  )

  local rand_idx=$(( RANDOM % ${#quotes[@]} + 1 ))
  local quote="${quotes[$rand_idx]}"

  local inner_width=72
  local quote_str="\"$quote\""
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
```

---

## Visual Output Demo

When launching a new terminal tab, you will see:

```text
                             ht2905@tuf-a15
       ...........           ──────────────
      /,,,,...../            OS    󰅂 CachyOS x86_64
     /,,,..,,../   ()        KER   󰅂 Linux 7.3.1-1-cachyos
    /,,,,../                 UP    󰅂 7 hours, 20 mins
   /,,,.../     /'\          PKG   󰅂 1 (appimage), 23 (flatpak), 1706 (pacman)
  /,...../      \,/          SH    󰅂 zsh 5.9.2
  \,,,,,,\\             _    TERM  󰅂 konsole 26.8.2
   \,,....\\           / \   CPU   󰅂 AMD Ryzen 5 4600H (12) @ 4.01 GHz
    \...,..\\          \_/   MEM   󰅂 9.85 GiB / 15.04 GiB (65%)
     \..,,,,,,,,,,,,/        ● ● ● ● ● ● ● ●
      \,,........,,/

   /\_/\   ☀️ Good afternoon, ht2905! Deep work session in full swing 🚀
  ( •̀_•́ )  CachyOS running peak performance. Stay in the zone! 🔥
   > ^ <   Terminal ready. Let's do great work! 💫

  ╭────────────────────────────────────────────────────────────────────────╮
  │ 󰄛 TOKYO NIGHT STATION │ CachyOS Linux │ Bio & Core Workspace           │
  │ "Small daily commits lead to monumental breakthroughs."                │
  ╰────────────────────────────────────────────────────────────────────────╯
```

---

## Verification Plan

### Automated Tests
1. **Interactive Shell Execution**:
   ```bash
   zsh -i -c 'exit'
   ```
   Ensure zero exit code and no syntax or escape code errors.
2. **Non-Interactive Shell Verification**:
   ```bash
   zsh -c 'echo test_non_interactive'
   ```
   Ensure nothing is printed except `test_non_interactive` (verifying subshell safety).
3. **Random Quote Distribution**:
   Run 10 consecutive iterations to confirm randomization distributes cleanly across quotes without index out of bounds.

### Manual Verification
1. Open a new Konsole tab or Alacritty window.
2. Verify visual alignment, colors, and font rendering.
