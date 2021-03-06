set nocompatible
filetype off
syntax on
color molokai
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required! 
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive.git'
Plugin 'tpope/vim-surround.git'
Plugin 'scrooloose/nerdcommenter.git'
Plugin 'scrooloose/nerdtree.git'
Plugin 'scrooloose/syntastic'
Plugin 'mileszs/ack.vim.git'
Plugin 'alexaitken/vim-rubytest.git'
Plugin 'vim-scripts/Rainbow-Parenthesis.git'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/YankRing.vim.git'
Plugin 'bling/vim-airline'
Plugin 'puppetlabs/puppet-syntax-vim'
Plugin 'git@github.com:Shougo/vimshell.vim'
Plugin 'git@github.com:Shougo/vimproc.vim'
"Plugin ''
"Plugin ''
"Plugin ''
call vundle#end()

filetype plugin indent on


set modelines=0

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set relativenumber
set undofile

let mapleader = ","
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85
set list
set listchars=tab:?\ ,eol:¬
set wildignorecase

nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

nnoremap ; :

au FocusLost * :wa

nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

nnoremap <leader>a :Ack 

nnoremap <leader>ft Vatzf

nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

nnoremap <leader>q gqip

nnoremap <leader>v V`]

nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <leader>eg <C-w><C-v><C-l>:e ~/.gvimrc<cr>

inoremap jj <ESC>

nnoremap <leader>w <C-w>v<C-w>l

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader><tab> :Scratch<cr>
nnoremap <leader>t :CtrlP<cr>
nnoremap <leader>b :CtrlPBuffer<cr>

nnoremap <silent> <leader>pe :! p4 edit $(readlink -f %)<cr>
nnoremap <silent> <leader>pn :! p4 edit -c $P4DONTCHECKIN $(readlink -f %)<cr>
nnoremap <silent> <leader>pa :! p4 add $(readlink -f %)<cr>
nnoremap <silent> <leader>pr :! p4 revert $(readlink -f %)<cr>
nnoremap <silent> <leader>pp :! p4 print $(readlink -f %)<cr>
nnoremap <silent> <leader>pt :! p4 filelog $(readlink -f %)<cr>
nnoremap <silent> <leader>pd :P4diff<cr>
nnoremap <silent> <leader>do :execute 'bdel ' . g:dfname<cr>:diffoff!<cr>:tabclose<cr>

command! -complete=shellcmd -nargs=+ Shell call g:RunShellCommand(<q-args>)
function! g:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  "tabnew
  botright new
  "setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile 
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  redir => message
  execute '!'. expanded_cmdline
  redir END
  silent put=message
  setlocal nomodifiable
  1
endfunction

nnoremap <leader>z :Shell 
nnoremap <leader>j :Shell jruby -J-Djruby.loadService.indexing.enabled=true -J-Xmx1024m -J-XX:MaxPermSize=512m %<cr>
nnoremap <leader>T :Shell jruby -J-Djruby.loadService.indexing.enabled=true -J-Xmx1300m -J-XX:MaxPermSize=256m -I $HOME/ruby -rfast_fail_runner test/all_tests.rb -v --runner=fastfail<cr>

command! P4diff call P4diff()
function! P4diff()
  let g:fname = @%
  echo g:fname
  if has('win32unix')
    let s:printcmd = '!p4 print -q -o `cygpath -am /tmp/diff/%` `cygpath -am %`'
  else
    let s:printcmd = '!p4 print -q -o /tmp/diff/% %'
  endif
  silent execute s:printcmd
  tabnew
  execute 'edit ' . g:fname
  let g:dfname = '/tmp/diff/' . g:fname
  execute 'vertical diffsplit ' . g:dfname
endfunction

command! Puts call Puts()
function! Puts()
  let s:word = expand('<cword>')
  let @s = 'puts "' . expand('%') .': ' . s:word . ' = #{' . s:word . '.inspect}"'
  o

  put s
endfunction
nnoremap <leader>l :Puts<cr>

" ruby test 
"let g:rubytest_cmd_test = 'jruby -J-Djruby.loadService.indexing.enabled=true -J-Xmx1024m -J-XX:MaxPermSize=512m %p' 
"let g:rubytest_cmd_testcase = 'jruby -J-Djruby.loadService.indexing.enabled=true -J-Xmx1024m -J-XX:MaxPermSize=512m %p -n '/%c/'' 
let g:rubytest_cmd_test = 'Shell rvm ruby-2.1.3 do zeus testrb %p' 
let g:rubytest_cmd_testcase = 'Shell rvm ruby-2.1.3 do zeus testrb %p -n "/%c/"' 
map <Leader>m <Plug>RubyTestRun
map <Leader>n <Plug>RubyFileRun
map <Leader>h <Plug>RubyTestRunLast

set backupdir=~/tmp/.vimbackup,/tmp
set directory=~/tmp/.vimbackup,/tmp
set undodir=~/tmp/.vimundo,/tmp
silent execute '!mkdir -p ~/tmp/.vimbackup'
silent execute '!mkdir -p ~/tmp/.vimundo'
"set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%{fugitive#statusline()}%{ruby_debugger#statusline()}%=%c,%l/%L\ %P

"CtrlP
let g:ctrlp_working_path_mode = '0'

" vertical diff
set diffopt=filler,vertical

"VimShell
" Use current directory as vimshell prompt.
let g:vimshell_prompt_expr = 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '

