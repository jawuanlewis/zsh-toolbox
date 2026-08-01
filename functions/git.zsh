########################################
######    Git Functions    ######
########################################

# Switch to the default branch and delete the branch you were just on.
# Uses a safe delete (git branch -d) by default, which refuses if the branch
# has unmerged commits. Pass --force to force-delete (-D) instead — useful
# for branches git can't detect as merged, e.g. after a squash/rebase merge.
bclean() {
  local force_delete=false

  case "$1" in
  --force) force_delete=true ;;
  "") ;;
  *)
    echo "\n⚠️ Usage: bclean [--force]"
    return 1
    ;;
  esac

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
  if $force_delete; then
    git branch -D "$branch" && echo ""
  elif ! git branch -d "$branch" 2>/dev/null; then
    echo "\n⚠️ '$branch' has commits git can't confirm are merged (common after a squash or rebase merge). Re-run as 'bclean --force' if you're sure it's safe to delete."
    return 1
  else
    echo ""
  fi

  grefresh
  echo "\n✅ Branch cleanup complete."
}

# Sync repos under $ZSH_TOOLBOX_REPOS_DIR, or the current directory if that's
# unset. Syncs everything by default; pass --prefix to only sync repos
# matching <prefix>-* (e.g. rpsync --prefix fin). Pass --safe to only sync
# repos that are on their default branch, with no other local branches and
# no uncommitted changes, skipping (and summarizing) anything that isn't.
rpsync() {
  local prefix=""
  local safe_mode=false

  while (($# > 0)); do
    case "$1" in
    --prefix)
      if [[ -z "$2" ]]; then
        echo "\n⚠️ --prefix requires a value  (e.g. rpsync --prefix fin)"
        return 1
      fi
      prefix="$2"
      shift 2
      ;;
    --safe)
      safe_mode=true
      shift
      ;;
    *)
      echo "\n⚠️ Usage: rpsync [--prefix <prefix>] [--safe]  (e.g. rpsync --prefix fin --safe)"
      return 1
      ;;
    esac
  done

  local using_fallback_dir=false
  [[ -z "$ZSH_TOOLBOX_REPOS_DIR" ]] && using_fallback_dir=true

  local base="${ZSH_TOOLBOX_REPOS_DIR:-$PWD}"
  local dirs
  local label

  if [[ ! -d "$base" ]]; then
    echo "\n⚠️ \$ZSH_TOOLBOX_REPOS_DIR is set to a directory that doesn't exist: $base"
    return 1
  fi

  if [[ -n "$prefix" ]]; then
    dirs=("$base"/${prefix}-*(/N))
    label="${prefix}-* repos"
  else
    dirs=("$base"/*(/N))
    label="repos under $base"
  fi

  if [[ ${#dirs[@]} -eq 0 ]]; then
    if [[ -n "$prefix" ]]; then
      echo "\n⚠️ No directories found matching: $base/${prefix}-*"
    else
      echo "\n⚠️ No directories found under: $base"
    fi
    if $using_fallback_dir; then
      echo "   (using the current directory — set \$ZSH_TOOLBOX_REPOS_DIR to always point at your repos folder)"
    fi
    return 1
  fi

  local -a skipped_not_default
  local -a skipped_extra_branches
  local -a skipped_dirty
  local repo_count=0

  for dir in "${dirs[@]}"; do
    [[ -d "$dir/.git" ]] || continue
    repo_count=$((repo_count + 1))
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

      local dirty=$(cd "$dir" && git status --porcelain)
      if [[ -n "$dirty" ]]; then
        echo "\n\033[1;33m⏭  Skipping $repo (uncommitted changes)\033[0m"
        skipped_dirty+=("$repo")
        continue
      fi
    fi

    echo "\n\033[1;34m── $repo ──\033[0m"
    (cd "$dir" && grefresh)
  done

  if ((repo_count == 0)); then
    echo "\n⚠️ No git repos found among directories under $base."
    if $using_fallback_dir; then
      echo "   (using the current directory — set \$ZSH_TOOLBOX_REPOS_DIR to always point at your repos folder)"
    fi
    return 1
  fi

  echo "\n✅ Done syncing $label."

  if $safe_mode && ((${#skipped_not_default[@]} > 0 || ${#skipped_extra_branches[@]} > 0 || ${#skipped_dirty[@]} > 0)); then
    echo "\n\033[1;35m── Skipped Summary ──\033[0m"
    if ((${#skipped_not_default[@]} > 0)); then
      echo "Not on default branch:"
      for r in "${skipped_not_default[@]}"; do
        echo "  - $r"
      done
    fi
    if ((${#skipped_extra_branches[@]} > 0)); then
      echo "Has extra local branches:"
      for r in "${skipped_extra_branches[@]}"; do
        echo "  - $r"
      done
    fi
    if ((${#skipped_dirty[@]} > 0)); then
      echo "Has uncommitted changes:"
      for r in "${skipped_dirty[@]}"; do
        echo "  - $r"
      done
    fi
  fi
}
