
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2019 Jan 26
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

call plug#begin('~/.vim/pack')

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'aarleks/zettel.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'preservim/nerdtree'

call plug#end()

" Custom
set relativenumber
set number
set splitright
set splitbelow
set listchars=tab:\|\ ,eol:<
set list
set noexpandtab
set tabstop=4
set shiftwidth=4
set autoindent
set cursorcolumn
set cursorline

" Custom key bindings
map m <C-w>

" Color scheme
colorscheme molokai

" Zettlekasten settings
let g:zettelkasten = '~/Knowledge/'
let mapleader = ','
setlocal spell spelllang=fr

map <Leader>zd :MarkdownPreviewToggle<CR>
map <Leader>zn /\[\[\S*.md\]\]<CR>
map ² :w<CR>:MarkdownPreviewStop<CR><C-6>
" :MarkdownPreviewToggle<CR>

nnoremap gf :w<CR>:MarkdownPreviewStop<CR>gf

" Pandoc settings
let maplocalleader = ','
let g:pandoc#modules#disabled = ['spell']
" let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#conceal#blacklist = ['subscript', 'superscript', 'atx']
let g:pandoc#hypertext#automatic_link_regex = '\[\[\S*.md\]\]'
let g:pandoc#hypertext#use_default_mappings = 0

" Rust settings
map <Leader>r :wa<CR>:!cargo run<CR>

" Nerdtree settings
map <Leader>n :NERDTreeToggle<CR>
