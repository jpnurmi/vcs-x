#!/bin/bash

export PATH="$(dirname "${BASH_SOURCE:-$0}"):$PATH"

srcdir=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)
source "$srcdir/complete-alias/complete_alias"

repo-cd() {
    local root=$(repo-root 2>/dev/null)
    if [ -n "$root" ]; then
        local project="$1"
        if [ -z "$project" ]; then
            cd "$root" || return 1
        else
            if [ -f ~/.rcd ]; then
                while read -r alias path; do
                    if [ "$project" = "$alias" ]; then
                        cd "$root/$path" || return 1
                        return 0
                    fi
                done < ~/.rcd
            fi
            local path=$(repo list -p "$project")
            cd "$root/$path" || return 1
        fi
    fi
}
export -f repo-cd
alias rcd='repo-cd'
complete -F _complete_alias rcd

_comp_idx() {
    local idx=0
    for ((i = 1; i < COMP_CWORD; i++)); do
        arg="${COMP_WORDS[i]}"
        if [[ $arg != -* ]]; then
            ((idx++))
            break
        fi
    done
    echo $idx
}

_complete_git_remote_checkout() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local opts="-h --help -r --rebase -t --track --no-track"
    local remotes=$(compgen -W "$REPO_REMOTES" -S /)
    COMPREPLY=($(compgen -W "$opts $remotes" -- $cur))
}
complete -F _complete_git_remote_checkout -o nospace git-remote-checkout

_complete_git_remote_dup() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local opts="-h --help --fetch --https --ssh --quiet"
    local remotes=""
    if [ "$(_comp_idx)" -eq 0 ]; then
        remotes="$(git remote)"
    else
        remotes="$REPO_REMOTES"
    fi
    COMPREPLY=($(compgen -W "$opts $remotes" -- $cur))
}
complete -F _complete_git_remote_dup git-remote-dup

_complete_git_remote_proto() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local opts="-h --help"
    local remotes="$(git remote)"
    COMPREPLY=($(compgen -W "$opts $remotes" -- $cur))
}
complete -F _complete_git_remote_proto git-remote-https
complete -F _complete_git_remote_proto git-remote-ssh

_complete_git_remote_tidy() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local opts="-h --help --no-branches --no-tags"
    local remotes="$(git remote)"
    COMPREPLY=($(compgen -W "$opts $remotes" -- $cur))
}
complete -F _complete_git_remote_tidy git-remote-tidy

_complete-repo-cd() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local names=$(repo list -nr "^$cur" 2>/dev/null)
    local aliases=
    if [ -f ~/.rcd ]; then
        while read -r alias path; do
            aliases="$aliases $alias"
        done < ~/.rcd
    fi
    COMPREPLY=($(compgen -W "$names $aliases" -- "$cur"))
}

_complete-repo-checkout() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="-h --help"
    local files=$(compgen -A file -- $cur)
    COMPREPLY+=($(compgen -W "$opts $files" -- "$cur"))
}

_complete-repo-fetch() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="-h --help"
    local names=$(repo list -nr "^$cur" 2>/dev/null)
    local remotes="origin upstream $REPO_REMOTES"
    COMPREPLY+=($(compgen -W "$opts $names $remotes" -- "$cur"))
}

_complete-repo-forall() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="
-h --help
-r --regex
-i --inverse-regex
-g --groups
-c --command
-e --abort-on-errors
--ignore-missing
-p
-v --verbose
-j --jobs
"
    local names=$(repo list -nr "^$cur" 2>/dev/null)
    COMPREPLY=($(compgen -W "$opts $names" -- "$cur"))
}

_complete-repo-help() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="-h --help"
    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}

_complete-repo-ignore() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="-h --help"
    local names=$(repo list -nr "^$cur" 2>/dev/null)
    COMPREPLY+=($(compgen -W "$opts $names" -- "$cur"))
}

_complete-repo-manifest() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    case "$prev" in
        -m|--manifest-name)
            local files=$(compgen -A file -X '!*.xml' -- $cur)
            COMPREPLY+=($(compgen -W "$files" -- "$cur"))
            ;;
    esac
}

_complete-repo-init() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="
-h --help
-v --verbose
-q --quiet
-u --manifest-url
-b --manifest-branch
-c --current-branch
-m --manifest-name
--mirror
--reference
--dissociate
--depth
--partial-clone
--clone-filter
--archive
--submodules
-g --groups
-p --platform
--clone-bundle --no-clone-bundle
--no-tags
--repo-url
--repo-rev
--no-repo-verify
--config-name
"
    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
    _complete-repo-manifest
}

_complete-repo-mirror() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="-h --help -j --jobs"
    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}

_complete-repo-project() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="-h --help -v --verbose"
    local names=$(repo list -nr "^$cur" 2>/dev/null)
    COMPREPLY=($(compgen -W "$opts $names" -- "$cur"))
}

_complete-repo-sync() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="
-h --help
-f --force-broken
--fail-fast
--force-sync
--force-remove-dirty
-l --local-only
--no-manifest-update --nmu
-n --network-only
-d --detach
-c --current-branch
-v --verbose
-q --quiet
-j --jobs
-m --manifest-name
--clone-bundle --no-clone-bundle
-u --manifest-server-username
-p --manifest-server-password
--fetch-submodules
--no-tags
--optimized-fetch
--retry-fetches
--prune
--skip-hook
-s --smart-sync
-t --smart-tag
--no-repo-verify
"
    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
    _complete-repo-manifest
}

_complete-repo-unignore() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local opts="-h --help"
    local names=$(repo list -nr "^$cur" 2>/dev/null)
    COMPREPLY+=($(compgen -W "$opts $names" -- "$cur"))
}

complete -F _complete-repo-cd repo-cd
complete -F _complete-repo-project repo-branch
complete -F _complete-repo-checkout repo-checkout
complete -F _complete-repo-help repo-clean
complete -F _complete-repo-project repo-diff
complete -F _complete-repo-fetch repo-fetch
complete -F _complete-repo-forall repo-forall
complete -F _complete-repo-ignore repo-ignore
complete -F _complete-repo-init repo-init
complete -F _complete-repo-mirror repo-mirror
complete -F _complete-repo-project repo-lfs-fetch
complete -F _complete-repo-project repo-lfs-pull
complete -F _complete-repo-fetch repo-pull
complete -F _complete-repo-help repo-reset
complete -F _complete-repo-help repo-rev-parse
complete -F _complete-repo-project repo-status
complete -F _complete-repo-sync repo-sync
complete -F _complete-repo-unignore repo-unignore
