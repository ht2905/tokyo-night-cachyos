# ==============================================================================
# POWERLEVEL10K - TOKYO NIGHT EDITION (24-BIT TRUECOLOR)
# Tuned for CachyOS & KDE Konsole
# Palette:
#   Night BG:  #1a1b26 | Storm BG: #24283b | Surface: #3b4261 | Slate: #565f89
#   FG:        #c0caf5 | Indigo:   #7aa2f7 | Cyan:    #7dcfff | Mint:  #9ece6a
#   Amber:     #e0af68 | Lavender: #bb9af7 | Coral:   #f7768e | Orange:#ff9e64
# ==============================================================================

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
    emulate -L zsh -o extended_glob

    # Unset all configuration options so `source ~/.p10k.zsh` applies cleanly.
    unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

    # Zsh >= 5.1 is required.
    [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

    # --- Tokyo Night 24-bit Palette Constants ---
    local tn_night='#1a1b26'
    local tn_storm='#24283b'
    local tn_surface='#3b4261'
    local tn_slate='#565f89'
    local tn_fg='#c0caf5'
    local tn_bright='#e0e6ff'
    local tn_indigo='#7aa2f7'
    local tn_cyan='#7dcfff'
    local tn_mint='#9ece6a'
    local tn_amber='#e0af68'
    local tn_orange='#ff9e64'
    local tn_lavender='#bb9af7'
    local tn_coral='#f7768e'

    # --- Prompt Layout ---
    typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        dir                     # current directory
        vcs                     # git status
    )

    typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
        status                  # exit code of the last command
        command_execution_time  # duration of the last command
        background_jobs         # presence of background jobs
        direnv                  # direnv status
        virtualenv              # python virtual environment
        anaconda                # conda / mamba environment
        pyenv                   # python version from pyenv
        nvm                     # node.js version from nvm
        nodeenv                 # node.js environment
        kubecontext             # current kubernetes context
        terraform               # terraform workspace
        aws                     # aws profile
        azure                   # azure account name
        gcloud                  # google cloud cli account and project
        toolbox                 # toolbox / distrobox name
        context                 # user@hostname (SSH / root only)
        yazi                    # yazi subshell indicator
        vim_shell               # vim shell indicator (:sh)
        nix_shell               # nix shell indicator
        vi_mode                 # vi mode indicator
        time                    # current time
    )

    typeset -g POWERLEVEL9K_MODE=nerdfont-v3
    typeset -g POWERLEVEL9K_ICON_PADDING=none
    typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=
    typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

    # --- Segmented Pill Separators ---
    typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0B1'
    typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='\uE0B3'
    typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B0'
    typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0B2'

    typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B6'
    typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='▓▒░'
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='░▒▓'
    typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B4'
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

    # --- Prompt Char (used if enabled or in transient prompt) ---
    typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND="$tn_cyan"
    typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND="$tn_coral"
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
    typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
    typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_{LEFT,RIGHT}_WHITESPACE=

    # --- Directory ---
    typeset -g POWERLEVEL9K_DIR_BACKGROUND="$tn_indigo"
    typeset -g POWERLEVEL9K_DIR_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND="$tn_storm"
    typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
    typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
    typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
    local anchor_files=(
        .bzr .citc .git .hg .svn .terraform CVS
        .node-version .python-version .go-version .ruby-version
        .tool-versions .mise.toml .shorten_folder_marker
        Cargo.toml composer.json go.mod package.json pyproject.toml
    )
    typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
    typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
    typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
    typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
    typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
    typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
    typeset -g POWERLEVEL9K_DIR_HYPERLINK=false
    typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3
    typeset -g POWERLEVEL9K_DIR_CLASSES=()

    # --- Git Status (VCS) ---
    typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND="$tn_mint"
    typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="$tn_amber"
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="$tn_lavender"
    typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND="$tn_coral"
    typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND="$tn_surface"

    typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
    typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

    function my_git_formatter() {
        emulate -L zsh

        if [[ -n $P9K_CONTENT ]]; then
            typeset -g my_git_format=$P9K_CONTENT
            return
        fi

        local meta='%F{#3b4261}'
        local clean='%F{#1a1b26}'
        local modified='%F{#1a1b26}'
        local untracked='%F{#1a1b26}'
        local conflicted='%F{#1a1b26}'

        local res

        if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
            local branch=${(V)VCS_STATUS_LOCAL_BRANCH}
            (( $#branch > 32 )) && branch[13,-13]="…"
            res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}${branch//\%/%%}"
        fi

        if [[ -n $VCS_STATUS_TAG && -z $VCS_STATUS_LOCAL_BRANCH ]]; then
            local tag=${(V)VCS_STATUS_TAG}
            (( $#tag > 32 )) && tag[13,-13]="…"
            res+="${meta}#${clean}${tag//\%/%%}"
        fi

        [[ -z $VCS_STATUS_LOCAL_BRANCH && -z $VCS_STATUS_TAG ]] &&
            res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"

        if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
            res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"
        fi

        if [[ $VCS_STATUS_COMMIT_SUMMARY == (|*[^[:alnum:]])(wip|WIP)(|[^[:alnum:]]*) ]]; then
            res+=" ${modified}wip"
        fi

        if (( VCS_STATUS_COMMITS_AHEAD || VCS_STATUS_COMMITS_BEHIND )); then
            (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
            (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
            (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
        fi

        (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
        (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
        (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
        (( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
        [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
        (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
        (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
        (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
        (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
        (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"

        typeset -g my_git_format=$res
    }
    functions -M my_git_formatter 2>/dev/null

    typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
    typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
    typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
    typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter()))+${my_git_format}}'
    typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1
    typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
    typeset -g POWERLEVEL9K_VCS_PREFIX='on '
    typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)

    # --- Exit Status ---
    typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
    typeset -g POWERLEVEL9K_STATUS_OK=true
    typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'
    typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND="$tn_mint"
    typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND="$tn_storm"

    typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
    typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'
    typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND="$tn_amber"
    typeset -g POWERLEVEL9K_STATUS_OK_PIPE_BACKGROUND="$tn_storm"

    typeset -g POWERLEVEL9K_STATUS_ERROR=true
    typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
    typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$tn_coral"

    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
    typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'
    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND="$tn_coral"

    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'
    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_BACKGROUND="$tn_coral"

    # --- Command Execution Time ---
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$tn_fg"
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$tn_surface"
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=
    typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX='took '

    # --- Background Jobs & Direnv ---
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND="$tn_cyan"
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND="$tn_storm"
    typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false

    typeset -g POWERLEVEL9K_DIRENV_FOREGROUND="$tn_amber"
    typeset -g POWERLEVEL9K_DIRENV_BACKGROUND="$tn_storm"

    # --- Python & Node Environments ---
    typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND="$tn_indigo"
    typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
    typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
    typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=

    typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND="$tn_cyan"
    typeset -g POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION='${${${${CONDA_PROMPT_MODIFIER#\(}% }%\)}:-${CONDA_PREFIX:t}}'

    typeset -g POWERLEVEL9K_PYENV_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_PYENV_BACKGROUND="$tn_indigo"
    typeset -g POWERLEVEL9K_PYENV_SOURCES=(shell local global)
    typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=true
    typeset -g POWERLEVEL9K_PYENV_CONTENT_EXPANSION='${P9K_CONTENT}${${P9K_CONTENT:#$P9K_PYENV_PYTHON_VERSION(|/*)}:+ $P9K_PYENV_PYTHON_VERSION}'

    typeset -g POWERLEVEL9K_NVM_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_NVM_BACKGROUND="$tn_lavender"
    typeset -g POWERLEVEL9K_NVM_PROMPT_ALWAYS_SHOW=false
    typeset -g POWERLEVEL9K_NVM_SHOW_SYSTEM=true

    typeset -g POWERLEVEL9K_NODEENV_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_NODEENV_BACKGROUND="$tn_mint"
    typeset -g POWERLEVEL9K_NODEENV_SHOW_NODE_VERSION=false
    typeset -g POWERLEVEL9K_NODEENV_{LEFT,RIGHT}_DELIMITER=

    # --- Cloud, Containers & Context ---
    typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|k9s|helmfile|flux|stern|kubecolor'
    typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=('*' DEFAULT)
    typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_BACKGROUND="$tn_lavender"
    typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION='${P9K_KUBECONTEXT_CLOUD_CLUSTER:-${P9K_KUBECONTEXT_NAME}}${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'
    typeset -g POWERLEVEL9K_KUBECONTEXT_PREFIX='at '

    typeset -g POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT=false
    typeset -g POWERLEVEL9K_TERRAFORM_CLASSES=('*' OTHER)
    typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND="$tn_indigo"
    typeset -g POWERLEVEL9K_TERRAFORM_OTHER_BACKGROUND="$tn_storm"

    typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|cdk|terraform|tofu|pulumi'
    typeset -g POWERLEVEL9K_AWS_CLASSES=('*' DEFAULT)
    typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_AWS_DEFAULT_BACKGROUND="$tn_orange"
    typeset -g POWERLEVEL9K_AWS_CONTENT_EXPANSION='${P9K_AWS_PROFILE//\%/%%}${P9K_AWS_REGION:+ ${P9K_AWS_REGION//\%/%%}}'

    typeset -g POWERLEVEL9K_AZURE_SHOW_ON_COMMAND='az|terraform|tofu|pulumi'
    typeset -g POWERLEVEL9K_AZURE_CLASSES=('*' OTHER)
    typeset -g POWERLEVEL9K_AZURE_OTHER_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_AZURE_OTHER_BACKGROUND="$tn_indigo"

    typeset -g POWERLEVEL9K_GCLOUD_SHOW_ON_COMMAND='gcloud|gcs|gsutil'
    typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_GCLOUD_BACKGROUND="$tn_indigo"
    typeset -g POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_ID//\%/%%}'
    typeset -g POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_NAME//\%/%%}'
    typeset -g POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS=60

    typeset -g POWERLEVEL9K_TOOLBOX_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_TOOLBOX_BACKGROUND="$tn_amber"
    typeset -g POWERLEVEL9K_TOOLBOX_CONTENT_EXPANSION='${P9K_TOOLBOX_NAME:#fedora-toolbox-*}'
    typeset -g POWERLEVEL9K_TOOLBOX_PREFIX='in '

    typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="$tn_coral"
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="$tn_storm"
    typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND="$tn_amber"
    typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_BACKGROUND="$tn_storm"
    typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND="$tn_fg"
    typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND="$tn_storm"
    typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n@%m'
    typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n@%m'
    typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
    typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=
    typeset -g POWERLEVEL9K_CONTEXT_PREFIX='with '

    # --- Subshells & Vi Mode ---
    typeset -g POWERLEVEL9K_YAZI_FOREGROUND="$tn_amber"
    typeset -g POWERLEVEL9K_YAZI_BACKGROUND="$tn_storm"

    typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_VIM_SHELL_BACKGROUND="$tn_mint"

    typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_NIX_SHELL_BACKGROUND="$tn_indigo"

    typeset -g POWERLEVEL9K_VI_MODE_FOREGROUND="$tn_night"
    typeset -g POWERLEVEL9K_VI_COMMAND_MODE_STRING=NORMAL
    typeset -g POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND="$tn_mint"
    typeset -g POWERLEVEL9K_VI_VISUAL_MODE_STRING=VISUAL
    typeset -g POWERLEVEL9K_VI_MODE_VISUAL_BACKGROUND="$tn_indigo"
    typeset -g POWERLEVEL9K_VI_OVERWRITE_MODE_STRING=OVERTYPE
    typeset -g POWERLEVEL9K_VI_MODE_OVERWRITE_BACKGROUND="$tn_amber"
    typeset -g POWERLEVEL9K_VI_INSERT_MODE_STRING=
    typeset -g POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND="$tn_slate"

    # --- Time ---
    typeset -g POWERLEVEL9K_TIME_FOREGROUND="$tn_bright"
    typeset -g POWERLEVEL9K_TIME_BACKGROUND="$tn_slate"
    typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
    typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false
    typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=
    typeset -g POWERLEVEL9K_TIME_PREFIX='at '

    # --- Transient & Instant Prompt ---
    typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

    # Keep quiet instant prompt so CachyOS's p10k-instant-prompt cache never
    # emits console-output warnings when the interactive greeting banner runs.
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

    typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

    (( ! $+functions[p10k] )) || p10k reload
}

# Tell `p10k configure` which file it should overwrite.
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
