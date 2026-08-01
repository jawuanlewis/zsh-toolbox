########################################
######    Quick Utilities    ######
########################################

# Quick clone: qclone <org> <repo>
qclone() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "\n⚠️ Usage: qclone <org> <repo>  (e.g. qclone octocat hello-world)"
    return 1
  fi

  git clone "git@github.com:$1/$2.git"
}
