set expandtab
set tabstop=2
set shiftwidth=2
" クリップボードの有効化
set clipboard=unnamed,unnamedplus

let maplocalleader=","
autocmd FileType tidal setlocal commentstring=--\ %s
autocmd FileType tidal GitGutterDisable
nnoremap <localleader>n :NERDTreeFocus<CR>
nnoremap <localleader>N :NERDTreeToggle<CR>
inoremap <C-b> <BS>
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <silent> jj <ESC>

let g:scSplitDirection = "v"
let g:scSplitSize = 30
let g:NERDTreeWinSize = 15

call plug#begin()
Plug 'mynkit/vim-tidal', {'branch': 'dev/add-command'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mbbill/undotree'
Plug 'preservim/nerdtree'
Plug 'davidgranstrom/scnvim'
call plug#end()


lua << EOF
require('scnvim').setup()
EOF

