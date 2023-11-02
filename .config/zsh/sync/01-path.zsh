########################################
# 共通のツール設定
########################################

# dotfiles/bin
if [[ -e ~/dotfiles/bin ]]; then
    export PATH=$HOME/dotfiles/bin:$PATH
fi

# .local/bin
if [[ -e ~/.local/bin ]]; then
    export PATH=$HOME/.local/bin:$PATH
fi

# python
if [[ -e ~/.python/current ]]; then
    export PATH=$HOME/.python/current/bin:$PATH
    export WORKON_HOME=$HOME/venvs
fi
if [[ -e ~/.python/current/bin/virtualenvwrapper.sh ]]; then
    source ~/.python/current/bin/virtualenvwrapper.sh
fi

# poetry
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


########################################
# OS 別の個別設定
########################################

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

        # EDITOR
        # nvim内のterminalでnvimを開くとき、nvr を使うと入れ子にならずにもとのnvimで開き直してくれる
        # cf. https://github.com/mhinz/neovim-remote
        # VIMRUNTIME が設定されているかどうかで、nvim内かを見分ける
        if [ -n "$VIMRUNTIME" ]; then
            export EDITOR=nvr
            export VISUAL=nvr
            export GIT_EDITOR=nvr
            export NVIM_LISTEN_ADDRESS=$NVIM  # NVIMに変わったがnvrがNVIM_LISTEN_ADDRESSを見ている？
        else
            export EDITOR=$HOME/.linuxbrew/bin/nvim
            export VISUAL=$HOME/.linuxbrew/bin/nvim
            export GIT_EDITOR=$HOME/.linuxbrew/bin/nvim
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
        # export ZPLUG_HOME=$HOME/.linuxbrew/opt/zplug
        # source $ZPLUG_HOME/init.zsh

        #fzf
        PERCOL='fzf'

        #tmuximum
        alias t="tmuximum"

        #tmuxpのベース用起動。prefix keyが"\"になっている
        alias tt="tmuxp load tmuxp_base"

        ;;
esac

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
#export FZF_DEFAULT_OPTS='--height 40% --reverse'
export FZF_DEFAULT_OPTS='--color=fg+:11 --height 70% --reverse --exit-0 --multi --bind=ctrl-a:toggle-all --ansi --preview-window noborder'
