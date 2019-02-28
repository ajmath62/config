set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugin for TypeScript syntax highlighting
Plugin 'leafgarland/typescript-vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Set <Leader>
let mapleader = '@'
let maplocalleader = '\'

" Meta
nnoremap <Leader>f :tabnew ~/.vimrc<CR>
nnoremap <Leader>c :source ~/.vimrc<CR>

" Save with Control-S
nnoremap <C-S> :write<CR>
inoremap <C-S> <C-O>:write<CR>

" Always use spaces instead of tabs
set expandtab
set tabstop=2 shiftwidth=2
nnoremap <Leader><Space> :set expandtab!<CR>

" Language-specific changes
" Use 4 spaces for Python and 2 spaces for everything else
augroup python
  autocmd!
  autocmd FileType python setlocal foldmethod=indent shiftwidth=4 tabstop=4
augroup END
augroup vimscript
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  " Fold on page load
  autocmd FileType vim normal! zM
augroup END

" Switching tabs
nnoremap <Leader>th :tabp<CR>
nnoremap <Leader>tj :tabl<CR>
nnoremap <Leader>tk :tabr<CR>
nnoremap <Leader>tl :tabn<CR>
nnoremap <Leader>tn :tabnew 
nnoremap <Leader>tq :tabc<CR>

" Line numbering
set number
nnoremap <Leader>nn :set number!<CR>
nnoremap <Leader>nr :set relativenumber!<CR>

" Date insertion
" YYYY-MM-DD
nnoremap <Leader>dd "=strftime('%F')<CR>P
" Accept a format string from the user
nnoremap <expr> <Leader>du '"=strftime("' . input('') . '")<CR>P'
" YYYY
nnoremap <Leader>dy "=strftime('%Y')<CR>P

" Show commands as they're typed
set showcmd
" Show matching brackets
set showmatch

" Color modifications
highlight Comment ctermfg=green

" Search settings
" Search case-insensitively
" Use \C to turn off for a single search
set ignorecase
" Highlight searches as they're typed
set incsearch

" Always leave a little bit of space at the edges of the screen
set scrolloff=5

" Set .ts files to have filetype typescript (used for syntax highlighting)
augroup typescript
  autocmd!
  autocmd BufRead,BufNewFile *.ts set filetype=typescript
augroup END

" Set .xsh files to have filetype python (it's approximately correct)
augroup xonsh
  autocmd!
  autocmd BufRead,BufNewFile *.xsh set filetype=python
augroup END

" Git mappings
augroup git
  autocmd!
  " xx: Clear the whole file, save and quit. Aborts a git operation.
  autocmd FileType gitcommit,gitrebase nnoremap <buffer> <LocalLeader>xx ggdG:wq<CR>
  " a<l>: Replace the first word of the current line with letter <l>. Useful
  " for switching a rebase action.
  autocmd FileType gitrebase nnoremap <buffer> <expr> <LocalLeader>a 'cw' . nr2char(getchar()) . '<Esc>'
augroup END
