# vimから:term + command 即実行のときzshrcが呼ばれないので
if [ -n "$VIMRUNTIME" ]; then
    source ~/.zshrc
fi
