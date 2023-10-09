#######################################1
# 環境変数
export LANG=ja_JP.UTF-8
export ZSHRC_DIR=${${(%):-%N}:A:h}

# 256色使えるように
export TERM="xterm-256color"

# 色を使用出来るようにする
autoload -Uz colors
colors

# vi 風キーバインドにする
bindkey -v

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
PROMPT="%{${fg[red]}%}[%n@%m]%{${reset_color}%} %~
%# "

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit -u

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# vcs_info

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f|)"


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# = の後はパス名として補完する
setopt magic_equal_subst

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# ヒストリファイルに保存するとき、すでに重複したコマンドがあったら古い方を削除する
setopt hist_save_nodups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 補完候補が複数あるときに自動的に一覧表示する
setopt auto_menu

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# * ワイルドカードが使えないのとかの対応
setopt nonomatch

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

########################################
# エイリアス

alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# ccatの色
alias ccat='ccat -G String="_brown_" -G Plaintext="lightgrey" -G Punctuation="darkteal" -G Decimal="darkgreen" -G Keyword="green" -G Comment="darkgray" -G Tag="faint"'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi

# neovim等のために、configを設定する
export XDG_CONFIG_HOME="$HOME/.config"



# vim:set ft=zsh:


# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
#export FZF_DEFAULT_OPTS='--height 40% --reverse'
export FZF_DEFAULT_OPTS='--color=fg+:11 --height 70% --reverse --exit-0 --multi --bind=ctrl-a:toggle-all --ansi --preview-window noborder'



## 読み込み
#ZSHHOME="${HOME}/.zsh.d"

#if [ -d $ZSHHOME -a -r $ZSHHOME -a \
#     -x $ZSHHOME ]; then
#    for i in $ZSHHOME/*; do
#        [[ ${i##*/} = *.zsh ]] &&
#            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
#    done
#fi


# WSLのとき時刻合わせを定期的にしないとずれる
# sync HW clock
if [ -n "$WSLENV" ]; then
    sudo hwclock -s
fi

# linuxbrewを先に読み込む
if [[ -e ~/.linuxbrew ]]; then
    export PATH=$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH
fi

# sheldon読み込むかどうかの判定
export ZPLUG_LOAD_FLG="1"
if [ -n "$VIMRUNTIME" ]; then  # vimからのtermのとき速度向上のためやらない
    ZPLUG_LOAD_FLG="0"
fi

if [ "$ZPLUG_LOAD_FLG" = "1" ]; then
    eval "$(sheldon source)"
fi
