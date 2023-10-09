###################
# お便利関数
###################
# fgを使わずctrl+zで行ったり来たりする
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z


###################
# git関連
# cf. https://dev.classmethod.jp/articles/fzf-original-app-for-git-add/
# #################
function gadd() {
    local selected
    selected=$(unbuffer git status -s | fzf -m --height 100% --preview="echo {} | awk '{print \$2}' | xargs git diff --color" | awk '{print $2}')
    if [[ -n "$selected" ]]; then
        selected=$(tr '\n' ' ' <<< "$selected")
        selected=$(echo $selected | sed 's/\s*$//')  # strip
        git add $(echo $selected)
        echo "Completed: git add $selected"
    fi
}

