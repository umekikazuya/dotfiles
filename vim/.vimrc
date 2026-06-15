" ==============================================================================
" Options
" ==============================================================================

" 表示設定
syntax on
set showtabline=0 " タブラインを非表示
set list " 不可視文字を表示モードにする
set number " 行番号表示
set norelativenumber " 相対行番号を無効にする
set laststatus=2
set cursorline
let &listchars = 'tab:  ,lead:·,trail:·'

" エンコーディングとファイル設定
set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac

" 検索
set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch

" その他
set autowrite " フォーカスが外れた時に自動保存

" クリップボードをOSと共有する
set clipboard=unnamedplus

" 行の折り返し（ラップ）の設定
set nowrap

" スクロール時の余白（カーソルが画面端に来る前に行をスクロールさせる）
set scrolloff=8


" ==============================================================================
" Keymaps
" ==============================================================================

" インサートモード中に 'jj' を素早く入力すると Esc とみなす
inoremap jj <Esc>

" 入力モード中に Ctrl + h/j/k/l でカーソル移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" Copy Relative Path
function! s:copy_relative_path()
  let l:path = expand('%:.')
  if l:path ==# ''
    echohl WarningMsg | echo "Current buffer has no file path" | echohl None
    return
  endif
  let @+ = l:path
  echo "Copied: " . l:path
endfunction
nnoremap <silent> <leader>pwd :call <SID>copy_relative_path()<CR>