" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

" leaderをspaceにしよう
let mapleader = "\<Space>"

" クリップボードをWSL-Windows間で共有
"set clipboard&
"set clipboard^=unnamedplus

" vim->windowsのクリップボードコピー
function! WinClip() abort
    if system('uname -a | grep microsoft') != ''
        augroup myYank
            autocmd!
            "autocmd TextYankPost * :call system('clip.exe', @")
            autocmd TextYankPost * call system('iconv -f utf-8 -t utf-16le | clip.exe', @")
        augroup END
    endif
endfunction
command WinClip call WinClip()

" マウスいらない
set mouse=

" filetype検出
filetype on

" ENV
let $CACHE = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let $CONFIG = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let $DATA = empty($XDG_DATA_HOME) ? expand('$HOME/.local/share') : $XDG_DATA_HOME

" デフォルトのpython
let g:python3_host_prog = expand('$HOME/.python/nvim/bin/python')

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

" 記号がズレる対策
"set ambiwidth=double
"fzfの画面がずれるほうが致命的なのでいったんsingleにする
set ambiwidth=single

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
autocmd FileType markdown setlocal tabstop=2 shiftwidth=0 expandtab


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
"nnoremap <C-j> <C-w>j
"nnoremap <C-k> <C-w>k
"nnoremap <C-l> <C-w>l
"nnoremap <C-h> <C-w>h

" 補完
" set completeopt=menuone,noinsert
" cocとかぶるのでコメントアウト
" 矢印キーで補完候補選択を、ctrl+n/pで補完候補選択と同じ動作をする
inoremap <expr><Down> pumvisible() ? "<C-n>" : "<Down>"
inoremap <expr><Up> pumvisible() ? "<C-p>" : "<Up>"
"

"コマンドラインで、カレントディレクトリを入れよう
"C-xで入れられる
cnoremap <C-x> <C-r>=expand('%:p:h')<CR>/

" いまのパスをクリップボードに
command! YankFilename let @" = expand('%')

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


" terminalにてleader+ESCでコマンドモードに戻る
tnoremap <silent> <leader><ESC> <C-\><C-n>

" terminal insertモードではじめる
autocmd TermOpen * startinsert


" スクリプト直接実行
"function! s:Exec()
"   exe "!" . &ft . " %"
":endfunction
"command! Exec call <SID>Exec()
"map <silent> <C-P> :call <SID>Exec()<CR>


" terminalのトグルをctrl+tでやる
" 要 split-term
" cf. https://zenn.dev/taro0079/articles/6094881dcadf4d
let g:terminal_bufnr = -1
function! ToggleTerminal()
  if &buftype == 'terminal'
    " If the current buffer is a terminal, go back to the previous buffer
    execute "buffer #"
    execute "close"
  else
    " If the current buffer is not a terminal, try to find the terminal buffer
    if bufexists(g:terminal_bufnr)
      " If the terminal buffer exists, switch to it
      execute 'vsplit'
      execute "buffer " . g:terminal_bufnr
      execute "normal i"

    else
      " If no terminal buffer exists, create a new one and save its buffer number
      " terminal
      VTerm
      let g:terminal_bufnr = bufnr('%')
    endif

  endif

endfunction

" nnoremap <silent> <C-t> :call ToggleTerminal()<CR>
" tnoremap <silent> <C-t> <C-\><C-n>:call ToggleTerminal()<CR>
nnoremap <silent> <C-]> :call ToggleTerminal()<CR>
tnoremap <silent> <C-]> <C-\><C-n>:call ToggleTerminal()<CR>


" ウィンドウ最大化のトグル
" cf. https://qiita.com/grohiro/items/e3dbcc93510bc8c4c812
let g:toggle_window_size = 0
function! ToggleWindowSize()
  if g:toggle_window_size == 1
    exec "normal \<C-w>="
    let g:toggle_window_size = 0
  else
    :resize
    :vertical resize
    let g:toggle_window_size = 1
  endif
endfunction
nnoremap <silent> <A-m> :call ToggleWindowSize()<CR>
tnoremap <silent> <A-m> <C-\><C-n>:call ToggleWindowSize()<CR>


" terminalモードでctrl+w 系使う
tnoremap <C-W>j <cmd>wincmd j<cr>
tnoremap <C-W>k <cmd>wincmd k<cr>
tnoremap <C-W>h <cmd>wincmd h<cr>
tnoremap <C-W>l <cmd>wincmd l<cr>

" 確認処理を行う汎用関数
function! ConfirmActionAndCall(actionFunc)
  let user_input = input("call " . a:actionFunc . " (Y/N): ")
  if toupper(user_input) == 'Y'
    call a:actionFunc()
  else
    echo "Cancelled."
  endif
endfunction

function! ConfirmActionAndExec(commandStr)
  let user_input = input(a:commandStr . "? (Y/N): ")
  if toupper(user_input) == 'Y'
    execute a:commandStr
  else
    echo "Cancelled."
  endif
endfunction

" プロジェクトルートからの相対パスを表示する関数
function! GetRelativePathFromRoot()
  " プロジェクトルートを検出するための一般的なマーカーファイル
  let l:markers = ['.git', '.svn', '.hg', 'package.json', 'Cargo.toml', 'go.mod']
  
  " 現在のファイルのフルパスを取得
  let l:current_file = expand('%:p')
  let l:current_dir = fnamemodify(l:current_file, ':h')
  
  " ルートディレクトリを見つける
  let l:root_dir = ''
  let l:check_dir = l:current_dir
  
  while l:check_dir != '/'
    for l:marker in l:markers
      if filereadable(l:check_dir . '/' . l:marker) || isdirectory(l:check_dir . '/' . l:marker)
        let l:root_dir = l:check_dir
        break
      endif
    endfor
    
    if !empty(l:root_dir)
      break
    endif
    
    " 親ディレクトリに移動
    let l:check_dir = fnamemodify(l:check_dir, ':h')
  endwhile
  
  " ルートが見つからない場合は現在のファイル名を返す
  if empty(l:root_dir)
    return expand('%')
  endif
  
  " ルートからの相対パスを計算
  let l:relative_path = strpart(l:current_file, strlen(l:root_dir) + 1)
  
  return l:relative_path
endfunction

" ステータスラインに表示する場合の例
function! SetRelativePathInStatusLine()
  set statusline=%{GetRelativePathFromRoot()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P
endfunction

" コマンドとして使用する例
command! ShowRelativePath echo GetRelativePathFromRoot()

" マッピングの例 (F2キーで相対パスを表示)
nnoremap <F2> :ShowRelativePath<CR>
