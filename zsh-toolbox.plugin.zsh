########################################
######    zsh-toolbox loader    ######
########################################
# Sources every alias/function file in this repo. Compatible with manual
# `source`, oh-my-zsh custom plugins, and plugin managers (zinit, antidote,
# zplug, etc.) that source a repo's <name>.plugin.zsh entry point.

ZSH_TOOLBOX_DIR="${0:A:h}"

for file in "$ZSH_TOOLBOX_DIR"/aliases/*.zsh; do
  source "$file"
done

for file in "$ZSH_TOOLBOX_DIR"/functions/*.zsh; do
  source "$file"
done

unset file
