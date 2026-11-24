#!/usr/bin/env bash
# ==============================================================================
# TOKYO NIGHT BACKUP & MANIFEST ROLLBACK UTILITY
# Cleanly finalizes the installation or restores the exact pre-install state.
# ==============================================================================

set -euo pipefail

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

log_step()    { printf '%s==>%s %s%s%s\n' "${C_CYAN}" "${C_RESET}" "${C_BOLD}${C_PURPLE}" "$1" "${C_RESET}"; }
log_sub()     { printf '   %s› %s%s\n' "${C_INDIGO}" "$1" "${C_RESET}"; }
log_success() { printf '   %s✓ %s%s\n' "${C_MINT}" "$1" "${C_RESET}"; }
log_warn()    { printf '   %s! %s%s\n' "${C_AMBER}" "$1" "${C_RESET}"; }

find_legacy_backups() {
    shopt -s nullglob
    LEGACY_DIRS=("${HOME}"/.tokyo_night_backup_*)
    shopt -u nullglob
}

remove_dir_safely() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        rm -rf "$dir"
        log_success "Removed ${dir}"
    fi
}

print_menu() {
    printf '%s\n' "${C_INDIGO}"
    printf '  ╭─────────────────────────────────────────────────────────────╮\n'
    printf '  │          TOKYO NIGHT BACKUP & ROLLBACK UTILITY              │\n'
    printf '  ╰─────────────────────────────────────────────────────────────╯\n'
    printf '%s\n' "${C_RESET}"
    printf 'Backup state: %s%s%s\n\n' "${C_CYAN}" "${STATE_DIR}" "${C_RESET}"
    printf '%sPlease select an action:%s\n' "${C_BOLD}" "${C_RESET}"
    printf '  %s[1]%s %sFinalize & Clean Backups%s (Keep Tokyo Night active, remove backup snapshots)\n' "${C_CYAN}" "${C_RESET}" "${C_BOLD}" "${C_RESET}"
    printf '  %s[2]%s %sFull Rollback%s            (Restore exact pre-install files, symlinks & Konsole default)\n' "${C_CYAN}" "${C_RESET}" "${C_BOLD}" "${C_RESET}"
    printf '  %s[3]%s Cancel\n\n' "${C_CYAN}" "${C_RESET}"
}

action_finalize() {
    log_step "Finalizing Tokyo Night setup and removing backup snapshots..."
    remove_dir_safely "$STATE_DIR"

    find_legacy_backups
    local bdir
    for bdir in "${LEGACY_DIRS[@]}"; do
        remove_dir_safely "$bdir"
    done

    echo ""
    printf '%s✓ Tokyo Night suite finalized and backup snapshots cleaned up!%s\n\n' "${C_MINT}" "${C_RESET}"
}

action_rollback() {
    if [[ ! -f "$MANIFEST_FILE" ]]; then
        log_warn "No manifest found at ${MANIFEST_FILE}. Nothing to roll back."
        exit 1
    fi

    log_step "Replaying manifest in reverse to restore exact pre-install state..."

    local -a entries=()
    local line
    while IFS= read -r line; do
        [[ -n "$line" ]] && entries+=("$line")
    done < "$MANIFEST_FILE"

    local idx entry_type target extra
    for (( idx=${#entries[@]}-1; idx>=0; idx-- )); do
        IFS=$'\t' read -r entry_type target extra <<< "${entries[$idx]}"
        case "$entry_type" in
            FILE)
                local backup_src="${BACKUP_DIR}/${extra}"
                if [[ -f "$backup_src" ]]; then
                    mkdir -p "$(dirname "$target")"
                    [[ -L "$target" ]] && rm -f "$target"
                    cp -p "$backup_src" "$target"
                    log_sub "Restored file: ${target}"
                else
                    log_warn "Missing backup file for ${target} (${backup_src})"
                fi
                ;;
            SYMLINK)
                mkdir -p "$(dirname "$target")"
                rm -f "$target"
                ln -s "$extra" "$target"
                log_sub "Restored symlink: ${target} -> ${extra}"
                ;;
            ABSENT)
                if [[ -e "$target" || -L "$target" ]]; then
                    rm -f "$target"
                    log_sub "Removed installed file: ${target}"
                fi
                ;;
            KONSOLERC_DEFAULT)
                if command -v kwriteconfig6 &>/dev/null; then
                    if [[ "$extra" == "__EMPTY__" ]]; then
                        kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile --delete
                        log_sub "Cleared Konsole DefaultProfile in konsolerc"
                    else
                        kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile "$extra"
                        log_sub "Restored Konsole DefaultProfile to '${extra}'"
                    fi
                fi
                ;;
            *)
                log_warn "Unknown manifest entry type '${entry_type}' for ${target}"
                ;;
        esac
    done

    if command -v bat &>/dev/null; then
        bat cache --build >/dev/null 2>&1 || true
        log_sub "Rebuilt bat theme cache"
    fi

    remove_dir_safely "$STATE_DIR"

    echo ""
    printf '%s✓ Rollback complete! Original files, symlinks, and settings restored.%s\n' "${C_MINT}" "${C_RESET}"
    printf 'Run %sexec zsh%s to reload your shell.\n\n' "${C_CYAN}" "${C_RESET}"
}

main() {
    find_legacy_backups
    if [[ ! -f "$MANIFEST_FILE" && ${#LEGACY_DIRS[@]} -eq 0 ]]; then
        echo ""
        log_warn "No Tokyo Night backup state found at ${STATE_DIR}."
        echo "Your setup is already clean or backups were previously removed."
        echo ""
        exit 0
    fi

    local choice="${1:-}"
    if [[ -z "$choice" ]]; then
        print_menu
        read -r -p "Enter choice [1-3]: " choice
    fi

    case "$choice" in
        1|--finalize|-f)
            action_finalize
            ;;
        2|--rollback|--restore|-r)
            action_rollback
            ;;
        3|cancel|q)
            echo "Cancelled. No files modified."
            exit 0
            ;;
        *)
            log_warn "Invalid option '${choice}'. Usage: ./cleanup.sh [--finalize | --rollback]"
            exit 1
            ;;
    esac
}

main "$@"
