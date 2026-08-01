########################################
######    Quick Utilities    ######
########################################

# Quick clone: qclone <org> <repo> [--https|--ssh]
# Protocol defaults to $ZSH_TOOLBOX_CLONE_PROTOCOL (ssh or https), or ssh if unset.
qclone() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "\n⚠️ Usage: qclone <org> <repo> [--https|--ssh]  (e.g. qclone octocat hello-world)"
    return 1
  fi

  local org="$1"
  local repo="$2"
  local protocol="${ZSH_TOOLBOX_CLONE_PROTOCOL:-ssh}"

  case "$3" in
  --https) protocol="https" ;;
  --ssh) protocol="ssh" ;;
  "") ;;
  *)
    echo "\n⚠️ Unknown option: $3  (expected --https or --ssh)"
    return 1
    ;;
  esac

  local url
  if [[ "$protocol" == "https" ]]; then
    url="https://github.com/$org/$repo.git"
  else
    url="git@github.com:$org/$repo.git"
  fi

  git clone "$url"
}
