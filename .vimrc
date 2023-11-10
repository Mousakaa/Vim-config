
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
Plug 'preservim/nerdtree'
Plug 'lervag/vimtex'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-lists', {'do': 'yarn install --frozen-lockfile'} " mru and stuff
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'} " color highlighting

call plug#end()

" Custom
set relativenumber
set number
set splitright
set splitbelow
set listchars=tab:\|\ ,eol:<
set fillchars+=vert:║
set list
set noexpandtab
set tabstop=4
set shiftwidth=4
set autoindent
set cursorcolumn
set cursorline

packadd termdebug

" Custom key bindings (<C-w> is equivalent to WinKey - see Alacritty config)
map j gj
map k gk

noremap <C-w><CR> :vert term<CR>
noremap <C-w><S-CR> :term<CR>
noremap <C-w>t :tabnew<CR>
noremap <C-w>m :tabnext<CR>
noremap <C-w>M :tabprevious<CR>
noremap <C-w><Left> :vert res +10<CR>
noremap <C-w><Right> :vert res -10<CR>
noremap <C-w><Up> :res +5<CR>
noremap <C-w><Down> :res -5<CR>

tnoremap <C-w><CR> <C-w>:vert term<CR>
tnoremap <C-w><S-CR> <C-w>:term<CR>
tnoremap <C-w>t <C-w>:tabnew<CR>
tnoremap <C-w>m <C-w>:tabnext<CR>
tnoremap <C-w>M <C-w>:tabprevious<CR>
tnoremap <C-w><Left> <C-w>:vert res +10<CR>
tnoremap <C-w><Right> <C-w>:vert res -10<CR>
tnoremap <C-w><Up> <C-w>:res +5<CR>
tnoremap <C-w><Down> <C-w>:res -5<CR>

" Color scheme
let g:gruvbox_transparent_bg = 1
" let g:gruvbox_contrast_dark='hard'
let g:gruvbox_vert_split='bg0'
colorscheme gruvbox
set background=dark

let g:airline_powerline_fonts = 1

" Zettlekasten settings
let g:zettelkasten = '~/harddisk/Knowledge/'
let mapleader = ' '

map <Leader>zd :call system('zathura --fork /tmp/zetteldisplay.pdf')<CR>
map <Leader>ze :w<CR>:!pandoc --data-dir /home/nemo/.config/pandoc --listings --katex --template eisvogel -o /tmp/zetteldisplay.pdf %:p<CR><CR>
map <Leader>zr :w<CR>:!pandoc %:p -o /tmp/zetteldisplay.pdf<CR><CR>
map <Leader>zb :w<CR>:!pandoc %:p -o /tmp/zetteldisplay.pdf --bibliography=bibliography.bib --citeproc --csl=/home/nemo/.config/pandoc/ieee-embedded-systems-letters.csl<CR><CR>
"  -H ~/.config/pandoc/header.tex  <-- Add that when table problems
map <Leader>zn /\[\[\S*.md\]\]<CR>
map ² :w<CR><C-6>

" Pandoc settings
let maplocalleader = ','
let g:pandoc#modules#disabled = ['spell', 'formatting']
" let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#conceal#blacklist = ['subscript', 'superscript', 'atx']
let g:pandoc#hypertext#automatic_link_regex = '\[\[\S*.md\]\]'
let g:pandoc#hypertext#use_default_mappings = 0
let g:pandoc#folding#fastfolds = 1

" Rust settings
function ExitOnLeave(job, status)
	autocmd WinLeave <buffer> quit
endfunction

map <Leader>r :wa<CR>:call term_start("cargo run", {"exit_cb":"ExitOnLeave"})<CR><C-w>J<C-w>12_

" Nerdtree settings
map <Leader>n :NERDTreeToggle<CR>
let g:NERDTreeMapMenu = 'M'

" LaTex settings
filetype plugin indent on

syntax enable

let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'

" COC CONFIG

" https://github.com/neoclide/coc.nvim#example-vim-configuration
inoremap <silent><expr> <c-space> coc#refresh()

" gd - go to definition of word under cursor
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)

" gi - go to implementation
nmap <silent> gi <Plug>(coc-implementation)

" gr - find references
nmap <silent> gr <Plug>(coc-references)

" gh - get hint on whatever's under the cursor
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> gh :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction


" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

nnoremap <silent> <leader>co  :<C-u>CocList outline<cr>
nnoremap <silent> <leader>cs  :<C-u>CocList -I symbols<cr>

" List errors
nnoremap <silent> <leader>cl  :<C-u>CocList locationlist<cr>

" list commands available in tsserver (and others)
nnoremap <silent> <leader>cc  :<C-u>CocList commands<cr>

" restart when tsserver gets wonky
nnoremap <silent> <leader>cR  :<C-u>CocRestart<CR>

" view all errors
nnoremap <silent> <leader>cl  :<C-u>CocList locationlist<CR>

" manage extensions
nnoremap <silent> <leader>cx  :<C-u>CocList extensions<cr>

" rename the current word in the cursor
nmap <leader>cr  <Plug>(coc-rename)
nmap <leader>cf  <Plug>(coc-format-selected)
vmap <leader>cf  <Plug>(coc-format-selected)

" run code actions
vmap <leader>ca  <Plug>(coc-codeaction-selected)
nmap <leader>ca  <Plug>(coc-codeaction-selected)
