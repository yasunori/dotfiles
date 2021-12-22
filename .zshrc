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

# dotfiles/bin
if [[ -e ~/dotfiles/bin ]]; then
    export PATH=$HOME/dotfiles/bin:$PATH
fi

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

        #tmuxpのベース用起動。prefix keyが"\"になっている
        alias tt="tmuxp load tmuxp_base"

        ;;
esac

# vim:set ft=zsh:


# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
#export FZF_DEFAULT_OPTS='--height 40% --reverse'
export FZF_DEFAULT_OPTS='--color=fg+:11 --height 70% --reverse --exit-0 --multi --bind=ctrl-a:toggle-all --ansi --preview-window noborder'

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

###################
# notes関連
# notes-cli を導入した
# cf. https://github.com/rhysd/notes-cli
###################

# 最後スラッシュをつけないこと。notesmoveで使っている
export NOTES_CLI_HOME=$HOME/notes
export NOTES_CLI_TEMPLATE=$HOME/notes/template.md

# notes-new category filename
# ファイル名に日付が無ければ補完する
# あればedit、無ければnew
function notesnew() {
    local f
    local category
    local filename
    local cnt
    local filefullpath
    if [ -n "$1" ]; then
        category=$1
    else
        echo -n category?:
        read category
    fi

    if [ -n "$2" ]; then
        f=$2
    else
        echo -n filename?:
        read f
    fi

    # filenameに日付を補完する
    if [[ $f =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}.{0,} ]]; then
        filename=$f
    else
        filename=`notesdate`-$f
    fi

    filename=`echo ${filename// /-}`  # スペースは-に変換する
    filefullpath=`notesfullpath $category $filename`
    if [ ! -e "$filefullpath" ]; then
        # new
        # diary は notesの力を借りようかな
        # ほかはコピーで作ったほうがはやい
        if [[ $category =~ ^diary$ ]]; then
            notes new $category $filename
        else
            notesnewbyfullpath $filefullpath
        fi
    fi

    notesopen $filefullpath
}

# noteを開くとき、notes directoryに遷移すると補完などに便利なのでそうする
# vimのterminal内のときはやらない
function notesopen() {
    local filefullpath
    if [ -n "$1" ]; then
        filefullpath=$1
        if [ -z "$VIMRUNTIME" ]; then  # vimから呼ばれていないときはcdする
            (cd $NOTES_CLI_HOME && $EDITOR "$filefullpath")
        else
            $EDITOR "$filefullpath"
        fi
    fi
}

# ファイル用のdate表示
function notesdate() {
    local d
    export TZ="Asia/Tokyo"
    d=$(date "+%Y-%m-%d")
    unset TZ
    echo $d
}

# ヘッダ用のdate iso表示
function notesdateiso() {
    local d
    export TZ="Asia/Tokyo"
    d=$(date -I"seconds")
    unset TZ
    echo $d
}

# categoryとfilenameから絶対パスを取得
function notesfullpath() {
    local category
    local filename
    if [ -n "$1" ] && [ -n "$2" ]; then
        category=$1
        if [[ $2 =~ .md ]]; then
            filename=$2
        else
            filename=$2.md
        fi
        echo $NOTES_CLI_HOME/$category/$filename
    fi
}

# 絶対パスから現在のカテゴリを取得
function notescategory() {
    if [ -n "$1" ]; then
        echo $1 | sed -e "s@`echo $NOTES_CLI_HOME`/@@g" | sed -e "s@/`echo $(basename $1)`@@g"
    fi
}

# notesnewのエイリアス
# よく間違えるので作った
function notesadd() {
    notesnew $1 $2 $3
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
    local cnt
    if [ -n "$word" ]; then
        list=$(notes ls `echo ${opts}`)
        if [ -n "$list" ]; then
            # 1行だったらそのまま開く
            # TODO 1行表示がおかしいため
            cnt=$(notes ls `echo ${opts}` | xargs rg -l -i "$word" | wc -l)
            if [ $cnt = 1 ]; then
                file=$(notes ls `echo ${opts}` | xargs rg -l -i "$word")
                # $EDITOR "$file"
                notesopen $file
            else
                file=$(notes ls `echo ${opts}` | xargs rg -i "$word" | ccat | fzf --height=100% | awk -F: '{print $1}')
                if [ -n "$file" ]; then
                    notesopen $file
                fi
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
            file=$(notes ls `echo ${opts}` | rg -i $word | fzf --height 100% --preview "bat --color=always --style=grid --line-range :100 {}")
            if [ -n "$file" ]; then
                notesopen $file
            fi
        fi
    fi
}


function notesmove() {
    local new_category
    local filefullpath
    if [ -n "$1" ]; then
        new_category=$1
        echo "new_category?: $new_category"
    else
        echo -n new category?:
        read new_category
    fi

    filefullpath=$(notes ls | fzf)
    notesmoveone $new_category $filefullpath
}

# 1つのファイルについてカテゴリを移動させる
# new_category filefullpath_from
function notesmoveone() {
    local filefullpath_from
    local filefullpath_to
    local filename
    local category_from
    local category_to
    local category_key_from
    local category_key_to
    if [ -n "$1" ] && [ -n "$2" ]; then
        filefullpath_from=$2
        filename=`basename $filefullpath_from`
        category_from=`notescategory $filefullpath_from`
        category_to=$1
        filefullpath_to=`notesfullpath $category_to $filename`

        mv $filefullpath_from $filefullpath_to

        if [[ -e $filefullpath_to ]]; then
            category_key_fron="Category: $category_from"
            category_key_to="Category: $category_to"

            sed -i "s@`echo $category_key_fron`@`echo $category_key_to`@g" $filefullpath_to
        fi
    fi
}

# fullpathからnote作成
# notes 機能を使わずにがんばる
function notesnewbyfullpath() {
    local filefullpath
    if [ -n "$1" ]; then
        filefullpath=$1
        cp $NOTES_CLI_TEMPLATE $filefullpath
        notesrestructheader $filefullpath
    fi
}

# ファイルパスからheaderを再定義する
# ヘッダがない場合は作成する
function notesrestructheader() {
    local filefullpath
    local filename
    local category
    local title
    local category_key_from
    local category_key_to
    local created_key_from
    local created_key_to
    local current_created
    local header="default\n=====================\n<!--\n- Category: default\n- Tags:\n- Created: default\n-->\n"
    if [ -n "$1" ]; then
        filefullpath=$1

        # ファイルパスから正しいカテゴリやタイトルを切り出す
        filename=`basename $filefullpath`
        category=`notescategory $filefullpath`
        date=`echo $filename | sed -r 's/.*([0-9-]{10})\-.*/\1/g'`
        title=`echo $filename | sed -r 's/(^.*)\.md$/\1/g'`

        if [[ -e $filefullpath ]]; then
            # headerの確認
            current_2p=`sed -n 2P $filefullpath`
            if [ `echo $current_2p | grep '====='` ] ; then  # 2行目に=====があるかどうかで判断 TODO
                # do nothing
            else
                # headerのテンプレートを挿入
                sed -i -e "1i $header" $filefullpath
            fi

            # 1行目はタイトル
            sed -i -e "1d" $filefullpath
            sed -i -e "1i `echo $title`" $filefullpath

            # カテゴリの置換
            category_key_from="Category: .*$"
            category_key_to="Category: $category"
            sed -i "s@`echo $category_key_from`@`echo $category_key_to`@g" $filefullpath

            # Createdの置換
            # 1. filenameから取得したdateと、headerのdateが同じ
            #   -> おそらく正しいのでそのまま使う
            #
            # 2. filenameから取得したdateが本日の場合
            #   -> 現在時刻を入れてしまおう
            #
            # 3. filenameから取得したdateが本日ではない場合
            #   -> なんかおかしいが、headerを書き換えたいのだろう。dateT00:00:00

            # 現在のcreatedを取得
            current_created=`sed -n 6P $filefullpath | sed -r 's/\- Created: (.*)$/\1/g'`
            current_created_date=`sed -n 6P $filefullpath | sed -r 's/.*([0-9]{4}\-[0-9]{2}\-[0-9]{2}).*/\1/g'`
            today_date=`notesdate`
            if [ $current_created_date = $date ]; then
                # do nothing
            else
                if [ $date = $today_date ]; then
                    created_key_to="Created: `notesdateiso`"  # 今を入れる

                else
                    created_key_to="Created: `echo $date`T00:00:00+09:00"
                fi
                created_key_from="Created: .*$"
                sed -i "s@`echo $created_key_from`@`echo $created_key_to`@g" $filefullpath
            fi
        fi
    fi
}


# 日報
function notesdiary() {
    notesnew diary diary
}

# メモ
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

# チェックのついたチェックボックスを検索
function notesdone() {
    notesgrep "\[x\]"
}

# なんとなく合わせる
function notessave() {
    notes save
}

# pull
function notespull() {
    (cd $NOTES_CLI_HOME && git pull)
}

# n で呼び出す
function n() {
    local cmd
    if [ -n "$1" ]; then
        cmd=$1
        case "$cmd" in
            "list" ) noteslist ${@:2};;
            "grep" ) notesgrep ${@:2};;
            "add" ) notesnew $2 $3 $4;;
            "new" ) notesnew $2 $3 $4;;
            "memo" ) notesmemo;;
            "diary" ) notesdiary;;
            "todo" ) notestodo;;
            "done" ) notesdone;;
            "save" ) notessave;;
            "pull" ) notespull;;
        esac
    else
        # 基本はnoteslist
        noteslist
    fi
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
    # 2021-12-03 dev環境のtmuxpを手動で起動したいことが多く、ctrl+cをいつも押すので、自動起動をやめた
    # if [[ ! -n $TMUX && $- == *l* ]]; then
    #    tmuximum
    # fi
fi
