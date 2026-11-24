# ==============================================================================
# TOKYO NIGHT ENVIRONMENT & CLI INTEGRATION
# Sourced in ~/.zshrc for FZF, Bat, Autosuggestions, Syntax Highlighting & Greeting
# ==============================================================================

# --- FZF Tokyo Night Color Palette (idempotent across re-source) ---
if [[ "${FZF_DEFAULT_OPTS:-}" != *"#1a1b26"* ]]; then
    export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+${FZF_DEFAULT_OPTS} }--color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7 --color=fg+:#c0caf5,bg+:#24283b,hl+:#7dcfff --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a"
fi

# --- Zsh Autosuggestions (Tokyo Night Comment Slate) ---
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#565f89'

# --- Bat Tokyo Night Theme ---
export BAT_THEME="tokyonight_night"

# --- Zsh Syntax Highlighting (Truecolor Tokyo Night Palette) ---
# Declare associative array upfront so styles apply regardless of plugin load order.
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#7dcfff,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#7aa2f7,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#bb9af7,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#9ece6a,bold'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[path]='fg=#7aa2f7,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e,bold'

# ==============================================================================
# TOKYO NIGHT OPENING GREETING SEQUENCE
# Set TOKYO_NIGHT_GREETING=0 in ~/.zshrc to disable startup output.
# Set TOKYO_NIGHT_STATION_LABEL="Custom Label" to customize the box header.
# ==============================================================================
# Note: Do not check `[[ -t 0 ]]` or `[[ -t 1 ]]` here; Powerlevel10k instant
# prompt temporarily redirects fd 0/1/2 during ~/.zshrc sourcing, while $TTY
# remains populated for real interactive terminal sessions.
if [[ -o interactive && -n "${TTY:-}" && "${TOKYO_NIGHT_GREETING:-1}" != "0" ]]; then
    () {
        emulate -L zsh

        # 1. Fastfetch System Overview
        if (( $+commands[fastfetch] )); then
            fastfetch --pipe false
        fi

        # 2. Dynamic Time-of-Day Neon Greeting + Duo Cat
        zmodload -F zsh/datetime b:strftime p:EPOCHSECONDS 2>/dev/null || true
        local hour
        if (( $+builtins[strftime] )); then
            strftime -s hour '%H' "$EPOCHSECONDS"
        else
            hour="$(date +%H)"
        fi
        hour=$(( 10#$hour ))

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

        # 24-bit Truecolor Tokyo Night ANSI escapes
        local c_purple=$'\033[38;2;187;154;247m'
        local c_cyan=$'\033[38;2;125;207;255m'
        local c_blue=$'\033[38;2;122;162;247m'
        local c_mint=$'\033[38;2;158;206;106m'
        local c_slate=$'\033[38;2;86;95;137m'
        local c_reset=$'\033[0m'

        print -r -- ""
        print -r -- "${c_purple}   /\\_/\\  ${c_cyan} ${icon}${greeting}${c_reset}"
        print -r -- "${c_purple}  ${mood_face} ${c_blue} ${subline}${c_reset}"
        print -r -- "${c_purple}   > ^ <  ${c_mint} Terminal ready. Let's do great work! 💫${c_reset}"
        print -r -- ""

        # 3. Randomized Wisdom & Science Quotes
        local -a quotes=(
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
        local quote_str="\"${quotes[$rand_idx]}\""

        # Responsive box layout adapted to terminal width ($COLUMNS)
        local term_cols="${COLUMNS:-80}"
        if (( term_cols < 44 )); then
            print -r -- "${c_cyan}  ${quote_str}${c_reset}"
            print -r -- ""
            return 0
        fi

        local max_inner=$(( term_cols - 6 ))
        (( max_inner > 84 )) && max_inner=84
        local content_width=$(( max_inner - 2 ))

        local station_label="${TOKYO_NIGHT_STATION_LABEL:-CachyOS Workstation}"
        local h_part1="󰄛 TOKYO NIGHT STATION"
        local h_part2="CachyOS Linux"
        local h_part3="${station_label}"
        local header_plain header_colored

        if (( ${#h_part1} + 3 + ${#h_part2} + 3 + ${#h_part3} <= content_width )); then
            header_plain="${h_part1} │ ${h_part2} │ ${h_part3}"
            header_colored="${c_purple}󰄛 ${c_blue}TOKYO NIGHT STATION ${c_slate}│ ${c_mint}${h_part2} ${c_slate}│ ${c_cyan}${h_part3}"
        elif (( ${#h_part1} + 3 + ${#h_part2} <= content_width )); then
            header_plain="${h_part1} │ ${h_part2}"
            header_colored="${c_purple}󰄛 ${c_blue}TOKYO NIGHT STATION ${c_slate}│ ${c_mint}${h_part2}"
        else
            header_plain="${h_part1}"
            header_colored="${c_purple}󰄛 ${c_blue}TOKYO NIGHT STATION"
        fi

        # Word-wrap quote_str to fit within content_width
        local -a wrapped_lines=()
        local current_line="" word
        for word in ${=quote_str}; do
            if [[ -z "$current_line" ]]; then
                current_line="$word"
            elif (( ${#current_line} + 1 + ${#word} <= content_width )); then
                current_line+=" $word"
            else
                wrapped_lines+=("$current_line")
                current_line="$word"
            fi
        done
        [[ -n "$current_line" ]] && wrapped_lines+=("$current_line")

        # Tighten box width to the longest rendered line (at least 60 if space allows)
        local max_line_len=${#header_plain}
        local line
        for line in "${wrapped_lines[@]}"; do
            (( ${#line} > max_line_len )) && max_line_len=${#line}
        done
        local min_content=60
        (( min_content > content_width )) && min_content=$content_width
        (( max_line_len < min_content )) && max_line_len=$min_content

        local inner_width=$(( max_line_len + 2 ))
        local border="${(l:inner_width::─:)}"
        local h_pad_len=$(( max_line_len - ${#header_plain} ))
        local h_pad="${(l:h_pad_len:: :)}"

        print -r -- "${c_slate}  ╭${border}╮"
        print -r -- "  │ ${header_colored}${h_pad}${c_slate} │"
        for line in "${wrapped_lines[@]}"; do
            local l_pad_len=$(( max_line_len - ${#line} ))
            local l_pad="${(l:l_pad_len:: :)}"
            print -r -- "  │ ${c_cyan}${line}${l_pad}${c_slate} │"
        done
        print -r -- "  ╰${border}╯${c_reset}"
        print -r -- ""
    }
fi
