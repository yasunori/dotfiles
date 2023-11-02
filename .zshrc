########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
# bindkey '^R' history-incremental-pattern-search-backward

########################################
# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
#if which pbcopy >/dev/null 2>&1 ; then
#    # Mac
#    alias -g C='| pbcopy'
#elif which xsel >/dev/null 2>&1 ; then
#    # Linux
#    alias -g C='| xsel --input --clipboard'
#elif which putclip >/dev/null 2>&1 ; then
#    # Cygwin
#    alias -g C='| putclip'
#fi


# vim:set ft=zsh:

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
    ZPLUG_LOAD_FLG="1"  # 様子見だがsheldonにしたら速度向上した
fi

if [ "$ZPLUG_LOAD_FLG" = "1" ]; then
    eval "$(sheldon source)"
fi
