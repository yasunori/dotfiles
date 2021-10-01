" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

" ENV
let $CACHE = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let $CONFIG = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let $DATA = empty($XDG_DATA_HOME) ? expand('$HOME/.local/share') : $XDG_DATA_HOME

let g:python3_host_prog = expand('$HOME/.python/current/bin/python')

" Load rc file
function! s:load(file) abort
    let s:path = expand('$CONFIG/nvim/rc/' . a:file . '.vim')

    if filereadable(s:path)
        execute 'source' fnameescape(s:path)
    endif
endfunction

call s:load('plugins')

" バッファ切り替え時に、バッファを自動的にファイルに保存する
"set autowrite
" バックアップファイルを作成しない
set nobackup

" swpファイルはtmpに作るよ
set directory=/tmp

" pasteモードにする
" 補完とかはいって大変
" set paste

" 記号化ける
" set ambiwidth=double

"migemoつかう。要migemo.
"set migemo

"linuxの場合、これがないとdeleteキーきかない
set backspace=2

"ツールバーいらない
"set guioptions-=T

"バッファ切り替え時にUNDO消さない。あと保存しなくてよくする。
"注意！
set hidden
"スラッシュをフォルダ区切りに
set shellslash

" 基本のタブ設定
set tabstop=4
set shiftwidth=0
set expandtab

autocmd FileType python setlocal tabstop=4 shiftwidth=0 expandtab


"行番号出す
set number

"カーソル位置を記憶
if has("autocmd")
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
endif

"バッファのキーマッピング
"uniteに任せるのでコメントアウト
"map <LEFT> <ESC>:bp<CR>
"map <RIGHT> <ESC>:bn<CR>
"map <UP> <ESC>:ls<CR>

nnoremap j gj
nnoremap k gk

" CTRL-hjklでウィンドウ移動
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

"コマンドラインで、カレントディレクトリを入れよう
"C-xで入れられる
cnoremap <C-x> <C-r>=expand('%:p:h')<CR>/

"format.vimの設定
"format_join_spaceについて。連結の際、スペースが挿入されるかどうか。
"行末と次の行頭が……
"1:両方がマルチバイト文字(いわゆる全角文字)ならばスペースは挿入しない
"2:どちらか片方がマルチバイト文字ならばスペースは挿入しない
"3:デフォルト(基本的に挿入する)と同じ動作
let format_join_spaces = 2
"ぶら下げ許可幅
let format_allow_over_tw = 2
"

"set t_Co=256


syntax enable
colorscheme tender

" leaderをspaceにしよう
let mapleader = "\<Space>"

" スクリプト直接実行
"function! s:Exec()
"   exe "!" . &ft . " %"
":endfunction
"command! Exec call <SID>Exec()
"map <silent> <C-P> :call <SID>Exec()<CR>
