"---------------------------------------------------------------------------
" バッファ切り替え時に、バッファを自動的にファイルに保存する
"set autowrite
" バックアップファイルを作成しない
set nobackup
"set backup

"set ambiwidth=double

set ruler

"migemoつかう。要migemo.
"set migemo

"ツールバーいらない
"set guioptions-=T

"バッファ切り替え時にUNDO消さない。あと保存しなくてよくする。
"注意！
set hidden
" スラッシュをフォルダ区切りに
set shellslash
" ファイルのタブの幅
set tabstop=4
" 編集中でのタブの幅
set softtabstop=4
" インデントの幅
set shiftwidth=2

set number

"タブを明示的に
"set list
"set listchars=tab:\|>,eol:<

"拡張子で_vimrcを読み直す
"set fexrc

"キーマッピングバッファ編
map <LEFT> <ESC>:bp<CR>
map <RIGHT> <ESC>:bn<CR>
map <UP> <ESC>:ls<CR>

"キーマッピングタブ編
"map <C-r> <ESC>:set expandtab<CR>:retab<CR>

"ヤンクとクリップボードの同期
set clipboard+=unnamed

"バッファのプラグイン
"ファイルの上で d でバッファ減らし
"編集作業後に :bd でバッファごと消去
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchBuffs = 1

nnoremap j gj
nnoremap k gk

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

"set textwidth=76

"折り返した時のマージン
"set wrapmargin=1

""""
" VSTreeExplorer　要VSTreeExplorer
let g:treeExplVertical=1
let g:treeExplWinSize=40


"その他モード作成
"augroup filetypedetect
au BufNewFile,BufRead *.* set noexpandtab
" ファイルのタブの幅
au BufNewFile,BufRead *.* set tabstop=4
" 編集中でのタブの幅
au BufNewFile,BufRead *.* set softtabstop=0
" インデントの幅
au BufNewFile,BufRead *.* set shiftwidth=4
au BufNewFile,BufRead *.* set textwidth=0
augroup END

"txtモード作成
augroup filetypedetect
au BufNewFile,BufRead *.txt set expandtab
" ファイルのタブの幅
au BufNewFile,BufRead *.txt set tabstop=2
" 編集中でのタブの幅
au BufNewFile,BufRead *.txt set softtabstop=0
" インデントの幅
au BufNewFile,BufRead *.txt set shiftwidth=2
au BufNewFile,BufRead *.txt set textwidth=76
augroup END

set viminfo='20,\"500,:20,%,n~/.viminfo 
