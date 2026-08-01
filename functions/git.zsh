########################################
######    Git Functions    ######
########################################

# Switch to the default branch and delete the branch you were just on
bclean() {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  local default_branch=$(_zsh_toolbox_default_branch)

  if [[ "$branch" == "$default_branch" ]]; then
    echo "\n👍 Already on $default_branch. Running refresh only.\n"
    grefresh
    return
  fi

  echo "\n🔄 Switching from '$branch' to $default_branch..."
  git checkout "$default_branch" || return 1

  echo "\n🧼 Deleting local branch '$branch'..."
  git branch -D "$branch" && echo ""

  grefresh
  echo "\n✅ Branch cleanup complete."
}

# Sync all repos under $HOME/code matching a prefix (e.g. rpsync fin).
# Pass --safe to only sync repos that are on their default branch with no
# other local branches, skipping (and summarizing) anything that isn't.
rpsync() {
  if [[ -z "$1" ]]; then
    echo "\n⚠️ Usage: rpsync <prefix> [--safe]  (e.g. rpsync fin --safe)"
    return 1
  fi

  local prefix="$1"
  local safe_mode=false
  [[ "$2" == "--safe" ]] && safe_mode=true

  local base="$HOME/code"
  local dirs=("$base"/${prefix}-*(/N))

  if [[ ${#dirs[@]} -eq 0 ]]; then
    echo "\n⚠️ No directories found matching: $base/${prefix}-*"
    return 1
  fi

  local -a skipped_not_default
  local -a skipped_extra_branches

  for dir in "${dirs[@]}"; do
    [[ -d "$dir/.git" ]] || continue
    local repo=$(basename "$dir")

    if $safe_mode; then
      local default_branch=$(cd "$dir" && _zsh_toolbox_default_branch)
      local current_branch=$(cd "$dir" && git rev-parse --abbrev-ref HEAD 2>/dev/null)
      local branch_count=$(cd "$dir" && git branch --format='%(refname:short)' | wc -l | tr -d ' ')

      if [[ "$current_branch" != "$default_branch" ]]; then
        echo "\n\033[1;33m⏭  Skipping $repo (on '$current_branch', not $default_branch)\033[0m"
        skipped_not_default+=("$repo (on $current_branch)")
        continue
      fi

      if [[ "$branch_count" -gt 1 ]]; then
        echo "\n\033[1;33m⏭  Skipping $repo ($branch_count local branches)\033[0m"
        skipped_extra_branches+=("$repo ($branch_count branches)")
        continue
      fi
    fi

    echo "\n\033[1;34m── $repo ──\033[0m"
    (cd "$dir" && grefresh)
  done

  echo "\n✅ Done syncing ${prefix}-* repos."

  if $safe_mode && (( ${#skipped_not_default[@]} > 0 || ${#skipped_extra_branches[@]} > 0 )); then
    echo "\n\033[1;35m── Skipped Summary ──\033[0m"
    if (( ${#skipped_not_default[@]} > 0 )); then
      echo "Not on default branch:"
      for r in "${skipped_not_default[@]}"; do
        echo "  - $r"
      done
    fi
    if (( ${#skipped_extra_branches[@]} > 0 )); then
      echo "Has extra local branches:"
      for r in "${skipped_extra_branches[@]}"; do
        echo "  - $r"
      done
    fi
  fi
}
