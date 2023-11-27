set expandtab
set tabstop=2
set shiftwidth=2
" クリップボードの有効化
set clipboard=unnamed,unnamedplus
set number

let maplocalleader=","
autocmd FileType tidal setlocal commentstring=--\ %s
autocmd FileType tidal GitGutterDisable
autocmd FileType tidal set nonumber
nnoremap <localleader>n :NERDTreeFocus<CR>
nnoremap <localleader>N :NERDTreeToggle<CR>
inoremap <C-x> <BS>
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <silent> jj <ESC>

let g:scSplitDirection = "v"
let g:scSplitSize = 30
let g:NERDTreeWinSize = 15

let g:airline_theme = 'papercolor'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

call plug#begin()
Plug 'mynkit/vim-tidal', {'branch': 'dev/add-command'}
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mbbill/undotree'
Plug 'preservim/nerdtree'
Plug 'davidgranstrom/scnvim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
call plug#end()


" lua << EOF
" require('scnvim').setup()
" EOF

