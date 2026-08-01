########################################
######    Internal Helpers    ######
########################################

# Resolve the current repo's default branch (main, master, etc.) via
# origin/HEAD, falling back to a local main/master branch if origin/HEAD
# isn't set (e.g. shallow clones, or a remote HEAD that was never fetched).
_zsh_toolbox_default_branch() {
  local branch
  branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')

  if [[ -z "$branch" ]]; then
    if git show-ref --verify --quiet refs/heads/main; then
      branch="main"
    else
      branch="master"
    fi
  fi

  echo "$branch"
}
