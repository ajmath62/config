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

" Set .ts files to have filetype typescript (used for syntax highlighting)
au BufRead,BufNewFile *.ts setfiletype=typescript

" Always use spaces instead of tabs
set expandtab
map <C-Space> :set et!<CR>
map <C-@> <C-Space>

" Use 4 spaces for Python and 2 spaces for everything else
au FileType * set tabstop=2 shiftwidth=2
au FileType python set tabstop=4 shiftwidth=4

" Switching tabs
map <C-T>h :tabp<CR>
map <C-T>j :tabl<CR>
map <C-T>k :tabr<CR>
map <C-T>l :tabn<CR>
map <C-T>n :tabnew 
map <C-T>q :tabc<CR>

" Line numbering
set nu
map <C-N>n :set nu!<CR>
map <C-N>r :set rnu!<CR>

" Color modifications
highlight Comment ctermfg=green
