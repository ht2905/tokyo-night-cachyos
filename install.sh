#!/usr/bin/env bash
# ==============================================================================
# TOKYO NIGHT CUSTOMIZATION SUITE FOR CACHYOS / KDE KONSOLE
# Safe, idempotent, manifest-tracked installer.
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="${SCRIPT_DIR}/themes"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/tokyo-night-cachyos"
BACKUP_DIR="${STATE_DIR}/original-backup"
MANIFEST_FILE="${STATE_DIR}/manifest.tsv"

# --- Truecolor Tokyo Night ANSI Palette ---
readonly C_RESET=$'\033[0m'
readonly C_BOLD=$'\033[1m'
readonly C_INDIGO=$'\033[38;2;122;162;247m'
readonly C_CYAN=$'\033[38;2;125;207;255m'
readonly C_PURPLE=$'\033[38;2;187;154;247m'
readonly C_MINT=$'\033[38;2;158;206;106m'
readonly C_AMBER=$'\033[38;2;224;175;104m'
readonly C_SLATE=$'\033[38;2;86;95;137m'

MISSING_PKGS=()
CONFIGURED_COMPONENTS=()
SKIPPED_COMPONENTS=()

print_banner() {
    printf '%s\n' "${C_INDIGO}"
    printf '  ╭─────────────────────────────────────────────────────────────╮\n'
    printf '  │           TOKYO NIGHT SUITE FOR CACHYOS & KONSOLE           │\n'
    printf '  │       Konsole + Powerlevel10k + Bat + Micro + Fastfetch     │\n'
    printf '  ╰─────────────────────────────────────────────────────────────╯\n'
    printf '%s\n' "${C_RESET}"
}

log_step()    { printf '%s==>%s %s%s%s\n' "${C_CYAN}" "${C_RESET}" "${C_BOLD}${C_PURPLE}" "$1" "${C_RESET}"; }
log_sub()     { printf '   %s› %s%s\n' "${C_INDIGO}" "$1" "${C_RESET}"; }
log_success() { printf '   %s✓ %s%s\n' "${C_MINT}" "$1" "${C_RESET}"; }
log_warn()    { printf '   %s! %s%s\n' "${C_AMBER}" "$1" "${C_RESET}"; }

# Check if a target path is already recorded in the original-state manifest.
# Preserves the true pre-install snapshot across repeated install.sh runs.
manifest_has_target() {
    local target="$1"
    [[ -f "$MANIFEST_FILE" ]] && awk -F'\t' -v t="$target" '$2 == t { found=1; exit } END { exit !found }' "$MANIFEST_FILE"
}

# Record original state of a target file before modifying/replacing it.
# If target is a symlink, records its link target without mutating the external file.
backup_target() {
    local target="$1"
    mkdir -p "$BACKUP_DIR"
    touch "$MANIFEST_FILE"

    if manifest_has_target "$target"; then
        return 0
    fi

    if [[ -L "$target" ]]; then
        local link_dest
        link_dest="$(readlink "$target")"
        printf 'SYMLINK\t%s\t%s\n' "$target" "$link_dest" >> "$MANIFEST_FILE"
        log_sub "Recorded symlink ${target} -> ${link_dest} (external target untouched)"
    elif [[ -f "$target" ]]; then
        local rel_path="${target#/}"
        local backup_path="${BACKUP_DIR}/${rel_path}"
        mkdir -p "$(dirname "$backup_path")"
        cp -p "$target" "$backup_path"
        printf 'FILE\t%s\t%s\n' "$target" "$rel_path" >> "$MANIFEST_FILE"
        log_sub "Backed up ${target}"
    else
        printf 'ABSENT\t%s\t-\n' "$target" >> "$MANIFEST_FILE"
    fi
}

# Copy src to dest safely: backs up original state and unlinks any symlink first
# so external dotfiles repositories are never overwritten through symlinks.
safe_copy_file() {
    local src="$1"
    local dest="$2"
    backup_target "$dest"
    mkdir -p "$(dirname "$dest")"
    if [[ -L "$dest" ]]; then
        rm -f "$dest"
    fi
    cp "$src" "$dest"
}

# Materialize a symlinked config file into a local copy before in-place editing.
detach_symlink_for_edit() {
    local target="$1"
    backup_target "$target"
    if [[ -L "$target" ]]; then
        local tmp_file
        tmp_file="$(mktemp)"
        if [[ -f "$target" ]]; then
            cp "$target" "$tmp_file"
        fi
        rm -f "$target"
        mv "$tmp_file" "$target"
    fi
}

detect_nerd_font() {
    local candidates=(
        "MesloLGS NF"
        "MesloLGS Nerd Font"
        "JetBrainsMono Nerd Font"
        "JetBrainsMono NF"
        "FiraCode Nerd Font"
        "Hack Nerd Font"
        "CaskaydiaCove Nerd Font"
        "Iosevka Nerd Font"
    )
    if command -v fc-list &>/dev/null; then
        local installed_fonts
        installed_fonts="$(fc-list : family 2>/dev/null | tr ',' '\n' || true)"
        local font
        for font in "${candidates[@]}"; do
            if grep -Fqx "$font" <<< "$installed_fonts"; then
                printf '%s\n' "$font"
                return 0
            fi
        done
    fi
    return 1
}

write_konsole_profile() {
    local profile_path="$1"
    local profile_name="$2"
    local color_scheme="$3"
    local font_family="$4"

    backup_target "$profile_path"
    mkdir -p "$(dirname "$profile_path")"
    [[ -L "$profile_path" ]] && rm -f "$profile_path"

    cat << EOF > "$profile_path"
[General]
Name=${profile_name}
Parent=FALLBACK/

[Appearance]
ColorScheme=${color_scheme}
Font=${font_family},11,-1,5,400,0,0,0,0,0,0,0,0,0,0,1

[Scrolling]
HistoryMode=2
ScrollBarPosition=2
EOF
}

configure_konsole() {
    log_step "Step 1/5: Configuring KDE Konsole themes & profiles..."
    if ! command -v konsole &>/dev/null; then
        log_warn "konsole not found; skipping Konsole configuration."
        MISSING_PKGS+=("konsole")
        SKIPPED_COMPONENTS+=("Konsole")
        return 0
    fi

    local konsole_dir="${HOME}/.local/share/konsole"
    safe_copy_file "${THEMES_DIR}/konsole/TokyoNight.colorscheme" "${konsole_dir}/TokyoNight.colorscheme"
    safe_copy_file "${THEMES_DIR}/konsole/TokyoNightStorm.colorscheme" "${konsole_dir}/TokyoNightStorm.colorscheme"

    local font_family
    if font_family="$(detect_nerd_font)"; then
        log_sub "Detected Nerd Font: ${font_family}"
    else
        font_family="MesloLGS NF"
        log_warn "No Nerd Font detected via fc-list; defaulting Konsole profile to '${font_family}'."
        MISSING_PKGS+=("ttf-meslo-nerd")
    fi

    write_konsole_profile "${konsole_dir}/TokyoNight.profile" "Tokyo Night" "TokyoNight" "$font_family"
    write_konsole_profile "${konsole_dir}/TokyoNightStorm.profile" "Tokyo Night Storm" "TokyoNightStorm" "$font_family"
    log_sub "Created Tokyo Night & Tokyo Night Storm profiles in ${konsole_dir}"

    if command -v kwriteconfig6 &>/dev/null && command -v kreadconfig6 &>/dev/null; then
        if ! manifest_has_target "konsolerc:DefaultProfile"; then
            local prev_default
            prev_default="$(kreadconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile 2>/dev/null || true)"
            printf 'KONSOLERC_DEFAULT\tkonsolerc:DefaultProfile\t%s\n' "${prev_default:-__EMPTY__}" >> "$MANIFEST_FILE"
        fi
        kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile "TokyoNight.profile"
        log_success "Konsole default profile set to 'Tokyo Night' via kwriteconfig6!"
    else
        log_warn "kwriteconfig6 not found; select 'Tokyo Night' manually in Konsole Settings > Manage Profiles."
    fi

    CONFIGURED_COMPONENTS+=("Konsole")
}

configure_micro() {
    log_step "Step 2/5: Configuring Micro editor..."
    if ! command -v micro &>/dev/null; then
        log_warn "micro not found; skipping Micro configuration."
        MISSING_PKGS+=("micro")
        SKIPPED_COMPONENTS+=("Micro")
        return 0
    fi

    local micro_dir="${HOME}/.config/micro"
    safe_copy_file "${THEMES_DIR}/micro/tokyonight.micro" "${micro_dir}/colorschemes/tokyonight.micro"

    local settings_file="${micro_dir}/settings.json"
    detach_symlink_for_edit "$settings_file"
    mkdir -p "$micro_dir"

    if command -v jq &>/dev/null; then
        local tmp_json
        tmp_json="$(mktemp)"
        if [[ -s "$settings_file" ]] && jq empty "$settings_file" 2>/dev/null; then
            jq '.colorscheme = "tokyonight"' "$settings_file" > "$tmp_json"
        else
            jq -n '{colorscheme: "tokyonight"}' > "$tmp_json"
        fi
        mv "$tmp_json" "$settings_file"
    elif command -v python3 &>/dev/null; then
        python3 - "$settings_file" << 'PYEOF'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
data = {}
if path.exists():
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        data = {}
data["colorscheme"] = "tokyonight"
path.write_text(json.dumps(data, indent=4) + "\n", encoding="utf-8")
PYEOF
    else
        log_warn "Neither jq nor python3 found; set \"colorscheme\": \"tokyonight\" manually in ${settings_file}."
        SKIPPED_COMPONENTS+=("Micro settings.json")
        return 0
    fi

    log_success "Micro colorscheme set to 'tokyonight'!"
    CONFIGURED_COMPONENTS+=("Micro")
}

configure_bat() {
    log_step "Step 3/5: Configuring Bat pager..."
    if ! command -v bat &>/dev/null; then
        log_warn "bat not found; skipping Bat configuration."
        MISSING_PKGS+=("bat")
        SKIPPED_COMPONENTS+=("Bat")
        return 0
    fi

    local bat_config_dir
    bat_config_dir="$(bat --config-dir 2>/dev/null || printf '%s\n' "${HOME}/.config/bat")"
    safe_copy_file "${THEMES_DIR}/bat/tokyonight_night.tmTheme" "${bat_config_dir}/themes/tokyonight_night.tmTheme"

    local bat_config_file="${bat_config_dir}/config"
    detach_symlink_for_edit "$bat_config_file"
    mkdir -p "$bat_config_dir"

    local tmp_cfg
    tmp_cfg="$(mktemp)"
    if [[ -f "$bat_config_file" ]]; then
        grep -vE '^[[:space:]]*--theme([=[:space:]]|$)' "$bat_config_file" > "$tmp_cfg" || true
    fi
    printf '%s\n' '--theme="tokyonight_night"' >> "$tmp_cfg"
    mv "$tmp_cfg" "$bat_config_file"

    log_sub "Rebuilding bat theme cache..."
    bat cache --build >/dev/null
    log_success "Bat configured with 'tokyonight_night' theme!"
    CONFIGURED_COMPONENTS+=("Bat")
}

configure_fastfetch() {
    log_step "Step 4/5: Configuring Fastfetch..."
    if ! command -v fastfetch &>/dev/null; then
        log_warn "fastfetch not found; skipping Fastfetch configuration."
        MISSING_PKGS+=("fastfetch")
        SKIPPED_COMPONENTS+=("Fastfetch")
        return 0
    fi

    safe_copy_file "${THEMES_DIR}/fastfetch/config.jsonc" "${HOME}/.config/fastfetch/config.jsonc"
    log_success "Fastfetch config installed to ~/.config/fastfetch/config.jsonc!"
    CONFIGURED_COMPONENTS+=("Fastfetch")
}

find_p10k_theme_file() {
    local paths=(
        "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme"
        "/usr/share/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme"
        "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme"
        "${HOME}/powerlevel10k/powerlevel10k.zsh-theme"
    )
    local p
    for p in "${paths[@]}"; do
        if [[ -f "$p" ]]; then
            printf '%s\n' "$p"
            return 0
        fi
    done
    return 1
}

update_zshrc_managed_block() {
    local zshrc="$1"
    local start_marker="# >>> tokyo-night-cachyos >>>"
    local end_marker="# <<< tokyo-night-cachyos <<<"
    local block_content
    block_content=$(cat << 'EOF'
# >>> tokyo-night-cachyos >>>
[[ -f "$HOME/.config/zsh/tokyo-night-env.zsh" ]] && source "$HOME/.config/zsh/tokyo-night-env.zsh"
# <<< tokyo-night-cachyos <<<
EOF
)

    detach_symlink_for_edit "$zshrc"
    touch "$zshrc"

    local tmp_zshrc
    tmp_zshrc="$(mktemp)"

    if grep -Fq "$start_marker" "$zshrc" && grep -Fq "$end_marker" "$zshrc"; then
        awk -v start="$start_marker" -v end="$end_marker" -v repl="$block_content" '
            $0 == start { print repl; skip=1; next }
            $0 == end   { skip=0; next }
            !skip       { print }
        ' "$zshrc" > "$tmp_zshrc"
        mv "$tmp_zshrc" "$zshrc"
        log_sub "Updated managed Tokyo Night block in ~/.zshrc"
    elif grep -Fq "tokyo-night-env.zsh" "$zshrc"; then
        # Replace only the legacy 1-2 line sourcing snippet; preserve every other line intact.
        awk -v repl="$block_content" '
            /^# === TOKYO NIGHT SUITE INTEGRATION ===$/ { next }
            /tokyo-night-env\.zsh/ && !replaced { print repl; replaced=1; next }
            { print }
        ' "$zshrc" > "$tmp_zshrc"
        mv "$tmp_zshrc" "$zshrc"
        log_sub "Migrated existing tokyo-night-env.zsh line to managed block in ~/.zshrc"
    else
        cp "$zshrc" "$tmp_zshrc"
        printf '\n%s\n' "$block_content" >> "$tmp_zshrc"
        mv "$tmp_zshrc" "$zshrc"
        log_sub "Appended managed Tokyo Night block to ~/.zshrc"
    fi
}

configure_zsh() {
    log_step "Step 5/5: Configuring Zsh & Powerlevel10k..."
    if ! command -v zsh &>/dev/null; then
        log_warn "zsh not found; skipping Zsh & Powerlevel10k configuration."
        MISSING_PKGS+=("zsh")
        SKIPPED_COMPONENTS+=("Zsh/Powerlevel10k")
        return 0
    fi

    safe_copy_file "${THEMES_DIR}/zsh/tokyo-night.p10k.zsh" "${HOME}/.p10k.zsh"
    safe_copy_file "${THEMES_DIR}/zsh/tokyo-night-env.zsh" "${HOME}/.config/zsh/tokyo-night-env.zsh"
    update_zshrc_managed_block "${HOME}/.zshrc"

    if ! find_p10k_theme_file >/dev/null; then
        log_warn "Powerlevel10k theme file not detected on disk; install zsh-theme-powerlevel10k for the prompt."
        MISSING_PKGS+=("zsh-theme-powerlevel10k")
    fi

    if ! command -v fzf &>/dev/null; then
        log_warn "fzf not found; FZF palette variables are configured and will activate once fzf is installed."
        MISSING_PKGS+=("fzf")
    fi

    log_success "Zsh environment & truecolor Powerlevel10k configured!"
    CONFIGURED_COMPONENTS+=("Zsh/Powerlevel10k")
}

print_summary() {
    echo ""
    printf '%s═════════════════════════════════════════════════════════════════%s\n' "${C_INDIGO}" "${C_RESET}"
    printf '%s  TOKYO NIGHT SUITE INSTALLATION COMPLETE%s\n' "${C_BOLD}${C_CYAN}" "${C_RESET}"
    printf '%s  Backup state:%s %s%s%s\n' "${C_PURPLE}" "${C_RESET}" "${C_SLATE}" "${STATE_DIR}" "${C_RESET}"
    if [[ ${#CONFIGURED_COMPONENTS[@]} -gt 0 ]]; then
        printf '%s  Configured:%s   %s\n' "${C_MINT}" "${C_RESET}" "${CONFIGURED_COMPONENTS[*]}"
    fi
    if [[ ${#SKIPPED_COMPONENTS[@]} -gt 0 ]]; then
        printf '%s  Skipped:%s      %s\n' "${C_AMBER}" "${C_RESET}" "${SKIPPED_COMPONENTS[*]}"
    fi
    printf '%s═════════════════════════════════════════════════════════════════%s\n' "${C_INDIGO}" "${C_RESET}"

    if [[ ${#MISSING_PKGS[@]} -gt 0 ]]; then
        # Deduplicate missing packages
        local unique_pkgs=()
        local pkg seen existing
        for pkg in "${MISSING_PKGS[@]}"; do
            seen=0
            for existing in "${unique_pkgs[@]:-}"; do
                [[ "$existing" == "$pkg" ]] && seen=1 && break
            done
            (( seen == 0 )) && unique_pkgs+=("$pkg")
        done
        echo ""
        printf '%sOptional missing packages:%s\n' "${C_AMBER}" "${C_RESET}"
        printf '  sudo pacman -S --needed %s\n' "${unique_pkgs[*]}"
    fi

    echo ""
    printf 'To apply in your current shell: %sexec zsh%s\n' "${C_CYAN}" "${C_RESET}"
    printf 'To finalize or rollback later:  %s./cleanup.sh%s\n' "${C_CYAN}" "${C_RESET}"
    echo ""
}

main() {
    print_banner
    mkdir -p "$STATE_DIR"

    if [[ -f "$MANIFEST_FILE" ]]; then
        log_sub "Existing original backup detected at ${STATE_DIR}; preserving original snapshot."
    else
        log_sub "Initializing original-state backup manifest at ${STATE_DIR}"
    fi

    configure_konsole
    configure_micro
    configure_bat
    configure_fastfetch
    configure_zsh
    print_summary
}

main "$@"
