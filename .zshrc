#######################################1
# 環境変数
export LANG=ja_JP.UTF-8

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


########################################
# 共通のツール設定

# python
if [[ -e ~/.python/current ]]; then
    export PATH=$HOME/.python/current/bin:$PATH
    export WORKON_HOME=$HOME/venvs
fi
if [[ -e ~/.python/current/bin/virtualenvwrapper.sh ]]; then
    source ~/.python/current/bin/virtualenvwrapper.sh
fi
if [[ -e ~/.poetry ]]; then
    export PATH="$HOME/.poetry/bin:$PATH"
fi

# nodebrew があれば
if [[ -e ~/.nodebrew ]]; then
    export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

# rvm があれば
if [[ -e $HOME/.rvm ]]; then
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
    export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi

# rbenv があれば
if [[ -e $HOME/.rbenv ]]; then
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init - zsh)"
fi

# tmuxinator があれば
if [[ -e ~/.tmuxinator ]]; then
    [[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
fi

# nodebrew があれば
if [[ -e ~/.nodebrew ]]; then
    export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

# gems があれば
if [[ -e ~/extlib/gems ]]; then
    export GEM_HOME=~/extlib/gems
    export PATH=$PATH:/extlib/gems/bin/
fi

# インスタンス一覧
alias aws-list-instances="aws ec2 describe-instances --profile yasunori --output=table --query 'Reservations[].Instances[?Platform!=\`windows\`][]  .{InstanceId: InstanceId, PrivateIp: join(\`, \`, NetworkInterfaces[].PrivateIpAddress), GlobalIP: join(\`, \`, NetworkInterfaces[].Association.Pu  blicIp), Platform:Platform, State: State.Name, SecurityGroupId: join(\`, \`, SecurityGroups[].GroupId) ,Name: Tags[?Key==\`Name\`].Value|[0]}'"   

# インスタンス停止
alias aws-stop-instance="aws ec2 stop-instances --profile yasunori --instance-ids "

# インスタンス起動
alias aws-start-instance="aws ec2 start-instances --profile yasunori --instance-ids "

# インスタンス状態
alias aws-describe-instance="aws ec2 describe-instance-status --profile yasunori --instance-ids "



########################################
# OS 別の個別設定
case ${OSTYPE} in
    darwin*)
        #Mac用の設定
        export CLICOLOR=1
        alias ls='ls -G -F'

        # macvim使う
        alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
        alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

        # tmux
        #alias tmux='tmuxx'
        alias tm='tmuxx'
        alias tma='tmux attach'
        alias tml='tmux list-window'


        # rvm
        rvm use 2.0.0

        # node
        #nodebrew use v0.8

        # postgres
        export PGDATA=/usr/local/var/postgres

        # git
        export GIT_EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim

        # updatedbって打ちたい
        alias updatedb='sudo /usr/libexec/locate.updatedb'

        ;;
    linux*)
        #Linux用の設定
        #自分のvim使う
        alias vi='env LANG=ja_JP.UTF-8 $HOME/.linuxbrew/bin/nvim "$@"'
        alias vim='env LANG=ja_JP.UTF-8 $HOME/.linuxbrew/bin/nvim "$@"'
        # GIT_EDITOR
        export GIT_EDITOR=$HOME/.linuxbrew/bin/nvim

        # EDITOR
        # nvim内のterminalでnvimを開くとき、nvr を使うと入れ子にならずにもとのnvimで開き直してくれる
        # cf. https://github.com/mhinz/neovim-remote
        # VIMRUNTIME が設定されているかどうかで、nvim内かを見分ける
        if [ -n "$VIMRUNTIME" ]; then
            export EDITOR=nvr
        else
            export EDITOR=$HOME/.linuxbrew/bin/nvim
        fi

        # linuxbrew
        if [[ -e ~/.linuxbrew ]]; then
            export PATH=$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH
        fi

        # tmuxで256色使えない問題
        alias tmux='tmux -2'

        # tmuxコマンドをtmuximumに任せたとき、tmuxで256色使えない問題が発生したので
        export TERM=xterm-256color

        # zplug
        export ZPLUG_HOME=$HOME/.linuxbrew/opt/zplug
        source $ZPLUG_HOME/init.zsh

        #fzf
        PERCOL='fzf'

        #tmuximum
        alias t="tmuximum"

        ;;
esac

# vim:set ft=zsh:


# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --reverse'


###################
# notes関連
# notes-cli を導入した
# cf. https://github.com/rhysd/notes-cli
###################

export NOTES_CLI_HOME=$HOME/notes


# notes-new category filename
# ファイル名に日付が無ければ補完する
# あればedit、無ければnew
function notesnew() {
    local file
    local cnt
    if [ -n "$1" ] && [ -n "$2" ]; then
        if [[ $2 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
            file=$2
        else
            export TZ="Asia/Tokyo"
            file=$(date "+%Y-%m-%d")-$2
            unset TZ
            file=`echo ${file// /-}`
        fi
        cnt=$(notesexists $1 $file)
        if [ -z "$VIMRUNTIME" ] && cd $NOTES_CLI_HOME  # vimから開いたので無ければカレント変更
        if [ $cnt = "0" ]; then
            # new
            #export TZ="Asia/Tokyo"
            notes new $1 $file $3
        else
            # edit
            notes ls -c $1 | grep /$file.md | xargs $EDITOR
        fi
    fi
}


# ファイルが存在するかを返す
function notesexists() {
    local cnt
    if [ -n "$1" ] && [ -n "$2" ]; then
        cnt=$(notes ls -c $1 | grep -c $2.md)
        echo $cnt
    fi
}

# notesをgrepしてfzfして開く
# 該当行を表示したいために rg に -l をつけない。代わりにcatしてawkしてeditorに渡す
function notesgrep() {
    local -A opthash
    local opts
    local word
    zparseopts -D -A opthash -- c: t:
    opts=""
    if [[ -n "${opthash[(i)-c]}" ]]; then
      opts=" $opts -c ${opthash[-c]}"
    fi
    if [[ -n "${opthash[(i)-t]}" ]]; then
      opts=" $opts -t ${opthash[-t]}"
    fi
    word=$@

    local list
    local file
    if [ -n "$word" ]; then
        list=$(notes ls `echo ${opts}`)
        if [ -n "$list" ]; then
            file=$(notes ls `echo ${opts}` | xargs rg -i "$word" | ccat | fzf | awk -F: '{print $1}')
            if [ -n "$file" ]; then
                if [ -z "$VIMRUNTIME" ] && cd $NOTES_CLI_HOME  # vimから開いたので無ければカレント変更
                $EDITOR "$file"
            fi
        fi
    fi
}

# notes名をfindしてfzfして開く
function noteslist() {
    local -A opthash
    local opts
    local word
    zparseopts -D -A opthash -- c: t:
    opts=""
    if [[ -n "${opthash[(i)-c]}" ]]; then
      opts=" $opts -c ${opthash[-c]}"
    fi
    if [[ -n "${opthash[(i)-t]}" ]]; then
      opts=" $opts -t ${opthash[-t]}"
    fi
    word=$@

    local list
    local files
    local file
    if [ -z "$word" ]; then
        word="md"  # 必ずあるword=>全部出す
    fi
    list=$(notes ls `echo ${opts}`)
    if [ -n "$list" ]; then
        files=$(notes ls `echo ${opts}` | rg -i $word)
        if [ -n "$files" ]; then
            file=$(notes ls `echo ${opts}` | rg -i $word | fzf)
            if [ -n "$file" ]; then
                if [ -z "$VIMRUNTIME" ] && cd $NOTES_CLI_HOME  # vimから開いたので無ければカレント変更
                $EDITOR "$file"
            fi
        fi
    fi
}

# 日報
function notesdiary() {
    notesnew diary diary
}

# 即メモ
function notesmemo() {
    local file 
    if [ -n "$1" ]; then
        file=$1
    else
        echo -n filename?:
        read file
    fi
    notesnew memo $file
}

# チェックのついていないチェックボックスを検索
function notestodo() {
    notesgrep "\[\s\]"
}

# なんとなく合わせる
function notessave() {
    notes save
}

# pull
function notespull() {
(cd $NOTES_CLI_HOME && git pull)
}

# WSLのとき時刻合わせを定期的にしないとずれる
# sync HW clock
if [ -n "$WSLENV" ]; then
    sudo hwclock -s
fi

# zplug読み込むかどうかの判定
export ZPLUG_LOAD_FLG="1"
if [ -n "$VIMRUNTIME" ]; then  # vimからのtermのとき速度向上のためやらない
    ZPLUG_LOAD_FLG="0"
fi

if [ "$ZPLUG_LOAD_FLG" = "1" ]; then
    # zplug
    if [ ! ${ZPLUG_HOME:-default} = "default" ]; then
        # zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
        zplug "arks22/tmuximum", as:command
        zplug 'zsh-users/zsh-autosuggestions'


        # 未インストール項目をインストールする
        if ! zplug check --verbose; then
            printf "Install? [y/N]: "
            if read -q; then
                echo; zplug install
            fi
        fi

        # コマンドをリンクして、PATH に追加し、プラグインは読み込む
        zplug load --verbose
    fi

    # zplug後に必要な設定

    # autosuggestionsの色
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

    ## 最後
    # tmuxを自動起動。体裁はtmuximumに任せた
    if [[ ! -n $TMUX && $- == *l* ]]; then
        tmuximum
    fi
fi
