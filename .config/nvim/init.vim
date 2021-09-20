let mapleader = ","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
call plug#end()


""" Settings
set nohlsearch
set number
set mouse=a

" Change window title
set title

" Default to + register
set clipboard+=unnamedplus

" Split buffers to the objectively correct direction
set splitbelow
set splitright

" Indentation
set shiftwidth=2
set tabstop=2
set expandtab
set smartindent


""" Mappings
" Shortcut for split and tab navigation
map <C-h> <C-w>h 
map <C-j> <C-w>j 
map <C-k> <C-w>k 
map <C-l> <C-w>l 
map <C-i> :tabnext<CR>

" Non-distracted writing, full-screen
map <leader>f :Goyo \| set linebreak<CR>

" Spell checking
map <leader>o :setl spell! spelllang=en_us<CR>

" Run shellcheck on file
map <leader>s :!clear && shellcheck -x %<CR>

" Perform dot commands on visual blocks
vnoremap . :normal .<CR>

" Nerd tree
map <leader>n :NERDTreeToggle<CR>
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'

" Replace ex mode with gq (who uses ex mode?)
map Q gq


""" Filetype settings
" Disable auto-commenting on newline
autocmd FileType * setl formatoptions-=c formatoptions-=r formatoptions-=o

" Shortcut files
autocmd BufRead,BufNewFile bm-files*,*/bm-files.d/*,bm-dirs*,*/bm-dirs.d/* set ft=sh
autocmd BufWritePost bm-files*,*/bm-files.d/*,bm-dirs*,*/bm-dirs.d/* !shortcuts

" Xdefaults files
autocmd BufRead,BufNewFile [xX]resources,[xX]defaults set ft=xdefaults
autocmd BufWritePost [xX]resources,[xX]defaults !xrdb %

