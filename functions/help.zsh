########################################
######    Help    ######
########################################

# Print available zsh-toolbox aliases/functions, grouped by domain.
# Pass a domain (git, utils) to filter: zthelp git
zthelp() {
  local filter="$1"

  case "$filter" in
  "" | git | utils) ;;
  *)
    echo "\n⚠️ Usage: zthelp [git|utils]"
    return 1
    ;;
  esac

  echo "\n\033[1;36mzsh-toolbox\033[0m — quick reference (https://github.com/jawuanlewis/zsh-toolbox)"

  if [[ -z "$filter" || "$filter" == "git" ]]; then
    echo "\n\033[1;34m── Git (aliases/git.zsh, functions/git.zsh) ──\033[0m"
    printf "  \033[1m%-36s\033[0m %s\n" "gpull" "Pull the current repo's default branch from origin"
    printf "  \033[1m%-36s\033[0m %s\n" "gprune" "Prune stale remote-tracking branches"
    printf "  \033[1m%-36s\033[0m %s\n" "gbranches" "List local branches with tracking/ahead-behind info"
    printf "  \033[1m%-36s\033[0m %s\n" "grefresh" "Run gpull, gprune, and gbranches in sequence"
    printf "  \033[1m%-36s\033[0m %s\n" "bclean [--force]" "Switch to default branch, delete the one you were on"
    printf "  \033[1m%-36s\033[0m %s\n" "rpsync [--prefix <p>] [--safe]" "Sync repos under \$ZSH_TOOLBOX_REPOS_DIR (or \$PWD)"
  fi

  if [[ -z "$filter" || "$filter" == "utils" ]]; then
    echo "\n\033[1;34m── Utils (functions/utils.zsh) ──\033[0m"
    printf "  \033[1m%-36s\033[0m %s\n" "qclone <org> <repo> [--https|--ssh]" "Clone a GitHub repo without the full URL"
  fi

  echo "\n  Config: \033[1mZSH_TOOLBOX_CLONE_PROTOCOL\033[0m, \033[1mZSH_TOOLBOX_REPOS_DIR\033[0m — see README for details"
  echo "  Run any command with a bad flag to see its usage, or see the README for full docs.\n"
}
