let g:syntax_cmd = "skip"
syntax on
set runtimepath^=~/.vim
set fileformat=unix
set encoding=UTF-8
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent
set smarttab
set nowrap
set number
set signcolumn=yes
set scrolloff=8
set showcmd
set noerrorbells visualbell t_vb=
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set hlsearch
set noshowmode
nnoremap <CR> :noh<CR><CR>:<backspace>
set mouse=a
set termguicolors
set clipboard=unnamedplus
so ~/.vim/theme.vim
so ~/.vim/autoclose.vim
