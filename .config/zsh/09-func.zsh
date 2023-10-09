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


## コマンド履歴検索
function peco-history-selection() {
  BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | fzf`
  CURSOR=$#BUFFER

  zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection


## コマンド履歴からディレクトリ検索・移動
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-max 1000
  zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi
function peco-cdr () {
  local selected_dir="$(cdr -l | sed 's/^[0-9]* *//' | fzf)"
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N peco-cdr
bindkey '^E' peco-cdr


## カレントディレクトリ以下のディレクトリ検索・移動
function find_cd() {
  local selected_dir=$(find . -type d | fzf)
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N find_cd
bindkey '^X' find_cd


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

# インスタンス一覧
alias aws-list-instances="aws ec2 describe-instances --profile yasunori --output=table --query 'Reservations[].Instances[?Platform!=\`windows\`][]  .{InstanceId: InstanceId, PrivateIp: join(\`, \`, NetworkInterfaces[].PrivateIpAddress), GlobalIP: join(\`, \`, NetworkInterfaces[].Association.Pu  blicIp), Platform:Platform, State: State.Name, SecurityGroupId: join(\`, \`, SecurityGroups[].GroupId) ,Name: Tags[?Key==\`Name\`].Value|[0]}'"   

# インスタンス停止
alias aws-stop-instance="aws ec2 stop-instances --profile yasunori --instance-ids "

# インスタンス起動
alias aws-start-instance="aws ec2 start-instances --profile yasunori --instance-ids "

# インスタンス状態
alias aws-describe-instance="aws ec2 describe-instance-status --profile yasunori --instance-ids "
