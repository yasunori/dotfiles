" バッファ切り替え時に、バッファを自動的にファイルに保存する
"set autowrite
" バックアップファイルを作成しない
set nobackup

" pasteモードにする
" 補完とかはいって大変
set paste

" 記号化ける
set ambiwidth=double

"migemoつかう。要migemo.
"set migemo
"
"linuxの場合、これがないとdeleteキーきかない
set backspace=2

"ツールバーいらない
"set guioptions-=T

"バッファ切り替え時にUNDO消さない。あと保存しなくてよくする。
"注意！
set hidden
"スラッシュをフォルダ区切りに
set shellslash
"ファイルのタブの幅
set tabstop=4
"編集中でのタブの幅
set softtabstop=4
"インデントの幅
set shiftwidth=4
"タブをスペースに展開
set expandtab

"行番号出す
set number

"キーマッピングバッファ編 -> uniteに任せる？
"map <LEFT> <ESC>:bp<CR>
"map <RIGHT> <ESC>:bn<CR>
"map <UP> <ESC>:ls<CR>

"キーマッピングタブ編
"map <C-r> <ESC>:set expandtab<CR>:retab<CR>

"ヤンクとクリップボードの同期
set clipboard+=unnamed,autoselect

"バッファのプラグイン
"ファイルの上で d でバッファ減らし
"編集作業後に :bd でバッファごと消去
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchBuffs = 1

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

"set textwidth=76

"折り返した時のマージン
"set wrapmargin=1

set t_Co=256

if has('gui_macvim')
    set showtabline=2 " タブを常に表示
    set imdisable " IMを無効化
    set transparency=10 " 透明度を指定
    set antialias
    set guifont=Monaco:h14
    colorscheme macvim
endif


"if has("gui_running")
"  set fuoptions=maxvert,maxhorz
"  au GUIEnter * set fullscreen
"endif

syntax enable
colorscheme molokai

" python (効かないな……
"let $PYTHON_DLL="/Users/yasunori/.pythonbrew/pythons/Python-3.3.0/Frameworks/Python.framework/Versions/3.3/lib/libpython3.3.dylib"
"let $PYTHON3_DLL="/Users/yasunori/.pythonbrew/pythons/Python-3.3.0/Frameworks/Python.framework/Versions/3.3/lib/libpython3.3.dylib"


" スクリプト直接実行
function! s:Exec()
  exe "!" . &ft . " %"        
:endfunction         
command! Exec call <SID>Exec() 
map <silent> <C-P> :call <SID>Exec()<CR>


"""""""""""""""""""""""""""""""""""
" neobundle
"""""""""""""""""""""""""""""""""""
set nocompatible
filetype off

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
      call neobundle#rc(expand('~/.vim/bundle'))
    endif

" ここにインストールしたいプラグインのリストを書く
NeoBundle 'Shougo/unite.vim'
NeoBundle 'jmcantrell/vim-virtualenv'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Yggdroot/indentLine'
"NeoBundle 'kevinw/pyflakes-vim'
"NeoBundle 'nvie/vim-flake8'
NeoBundle 'The-NERD-tree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'vim-coffee-script'

filetype plugin on
filetype indent on

" neocompleteの起動
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 2
let g:neocomplete#enable_auto_close_preview=0
" Returnキーで、選択・改行なし
inoremap <expr><CR> pumvisible() ? neocomplete#close_popup() : "\<CR>"
" Tabで次へ
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" pythonのとき、jediとneocompleteを連携
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#auto_vim_configuration = 0
if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'

"frake8 呼び出してpep8チェック(py3が効かないのでsyntasticでやることにした)
"nnoremap  pep :call Flake8()

"indentlineの色（効かないな)
let g:indentLine_color_term = 239
let g:indentLine_char = '¦'

let g:jedi#popup_select_first = 0

""" Unite.vim
" 起動時にインサートモードで開始
"let g:unite_enable_start_insert = 1
" インサート／ノーマルどちらからでも呼び出せるようにキーマップ
nnoremap <silent> <C-f> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
inoremap <silent> <C-f> <ESC>:<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <C-b> :<C-u>Unite buffer file_mru<CR>
inoremap <silent> <C-b> <ESC>:<C-u>Unite buffer file_mru<CR>
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" unite.vim上でのキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  " 単語単位からパス単位で削除するように変更
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " ESCキーを2回押すと終了する
  nmap <silent><buffer> <ESC><ESC> q
 imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction

" NERDTree ntでトグル
noremap nt :NERDTreeToggle<CR>

" 引数無しのときはNERDTree起動
let file_name = expand("%")
if has('vim_starting') &&  file_name == ""
    autocmd VimEnter * NERDTree ./
endif

" シンタックスチェック
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2
" 79文字のやつは許して……
let g:syntastic_python_flake8_args = '--ignore="E501"'
" angular jsの属性をエラーにしないで
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" coffee
au BufRead,BufNewFile *.coffee            set filetype=coffee
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
" 保存時にコンパイル
autocmd BufWritePost *.coffee silent CoffeeMake! -cb | cwindow | redraw!
