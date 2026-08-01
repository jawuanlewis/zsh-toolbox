########################################
######    Git Aliases    ######
########################################

# Pull the current repo's default branch (main/master/etc.) from origin
alias gpull='git pull origin "$(_zsh_toolbox_default_branch)"'

# Prune stale remote-tracking branches
alias gprune="git fetch --prune"

# List local branches with tracking/ahead-behind info
alias gbranches="git branch -vv"

# Refresh: pull default branch, prune stale remotes, list branches
alias grefresh="gpull && gprune && gbranches"
