" some of the machines I use has a read-only home directory
"  and it's pretty terrible. this is for working around that
let s:on_broken_machine = len($BROKEN_WORKSERVER_DIR) > 0
let s:on_work_machine =  len($ON_WORK_MACHINE) > 0

if !s:on_broken_machine
    " vundle is all kinds of broken on a read-only home dir :/
    filetype off

    set rtp+=$VUNDLE_RTP

    call vundle#begin()

    Plugin 'VundleVim/Vundle.vim'
    Plugin 'derekwyatt/vim-scala'
    Plugin 'sartak/sumi'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'mustache/vim-mustache-handlebars'
    Plugin 'nanotech/jellybeans.vim'

    Bundle 'ervandew/supertab'
    Bundle 'Valloric/YouCompleteMe'
    Bundle 'davidhalter/jedi'
    Bundle 'SirVer/ultisnips'
    Bundle 'nvie/vim-flake8'
    Bundle 'junegunn/fzf'
    "Plugin 'scrooloose/syntastic'

    Bundle 'romainl/vim-qf'

    call vundle#end()
endif

filetype plugin indent on

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF


set encoding=utf8
"let python_highlight_all=1
syntax on
set ruler
set rulerformat=%40(%=%t%h%m%r%w%<\ (%n)\ %4.7l,%-7.(%c%V%)\ %P%)
set showmode
set showcmd
set shortmess=aotTWI
set laststatus=2
set display+=lastline,uhex
set scrolloff=3
set lazyredraw
set hlsearch
set showmatch
set matchtime=1
set report=0
set nomore
set noswapfile
set autoread
set ttyfast
set completeopt=menuone
set incsearch
set tildeop
set backspace=indent,eol,start
"set wildmenu
set wildignore+=.log,.out,.o
if s:on_broken_machine
    let &viminfo="!,'1000,f1,/1000,:1000,<1000,@1000,h,n"+$BROKEN_WORKSERVER_DIR+"/.viminfo"
else
    set viminfo=!,'1000,f1,/1000,:1000,<1000,@1000,h,n~/.viminfo
endif
set isfname+=:
set wildmode=longest,list,full
set hidden
set vb t_vb=
set ttimeoutlen=1

set tabstop=4
set shiftwidth=4
set softtabstop=4

set shiftround
set autoindent
set smartindent

set foldenable
set foldmethod=marker

set backupskip=/tmp/*,/private/tmp/*"

let s:tmux = 0
set rtp+=~/.fzf

let workrepo=substitute(system('git config jason.workrepo'), '\n', '', '')
if workrepo=="true"
    set noexpandtab
else
	set expandtab
endif

let g:EclimCompletionMethod = 'omnifunc'

if hostname() !~ "path" && hostname() !~ "data"
    let &term="xterm-256color"
    colorscheme sumi
endif
set bg=dark

match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

highlight Search NONE ctermfg=lightred
highlight Folded      ctermbg=black ctermfg=blue

autocmd BufNewFile,BufRead *.reg,*.run,repl.rc,*.repl.rc,*.psgi,*.t set ft=perl
autocmd BufNewFile,BufRead *.asl       set ft=ruby
autocmd BufNewFile,BufRead psql.edit.* set ft=sql
autocmd BufNewFile,BufRead *.tt,*.tt2  set ft=tt2html
autocmd BufNewFile,BufRead *.json      set ft=json
autocmd BufNewFile,BufRead *.p6,*.pm6  set ft=perl6
autocmd BufNewFile,BufRead *.scpt      set ft=applescript
autocmd BufNewFile,BufRead Xdefaults   set ft=Xdefaults
autocmd BufNewFile,BufRead share/html/* set ft=mason
autocmd BufNewFile,BufRead etc/upgrade/*/content set ft=perl
autocmd BufNewFile,BufRead *.md      set ft=markdown

autocmd FileType ruby,eruby,html,haml,coffee,python set ts=2 sw=2 sts=2
autocmd FileType java set ts=3 sw=3 sts=3
autocmd FileType javascript,perl set ts=4 sw=4 sts=4

autocmd FileType           perl setlocal makeprg=$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
autocmd FileType           perl setlocal errorformat=%f:%l:%m

autocmd FileType php setlocal keywordprg=/Users/jason/pear/bin/pman

"if exists('*Flake8')
    autocmd BufWritePost *.py call Flake8()
"endif

" Automatic commands
autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
hi EOLWS ctermbg=red


autocmd FileType help nnoremap <buffer> <CR> <C-]>
autocmd FileType help nnoremap <buffer> <BS> <C-T>

function! <SID>BackToLastPosition()
  if line("'\"") > 0 && line("'\"") <= line("$")
    exe "normal g`\""
  endif
endfunction
autocmd BufReadPost * call <SID>BackToLastPosition()

" Mappings

inoremap <silent> <C-a> <ESC>u:set paste<CR>.:set nopaste<CR>gi

nmap     Y          y$

nmap     <Right>    :bn<CR>
nmap     <Left>     :bp<CR>

imap     <Right>    <C-o>:bn<CR>
imap     <Left>     <C-o>:bp<CR>

nmap     H          ^
vmap     H          ^
nmap     L          $
vmap     L          $

nmap     M          :nohl<CR>:syn on<CR>:syntax sync fromstart<CR>:set background=dark<CR><C-k>

nmap     <Left>     :bn<CR>
nmap     <Right>    :bp<CR>

nmap     <CR>       o<Esc>
nmap     <F1>       <Esc>
inoremap <F1>       <Esc>

inoremap <c-j> <c-r>=TriggerSnippet()<cr>

nnoremap -          <Space>

map      <Leader>p :set paste<CR>:r!pbpaste<CR>:set nopaste<CR>

nmap <C-n> :silent cnext<CR>
nmap <C-p> :silent cprev<CR>

nmap      <Leader>,t :!for s in $(seq 1 15); do echo; done;sbt test<cr>
nmap      <Leader>,r :!for s in $(seq 1 15); do echo; done;sbt run<cr>
nmap      <Leader>,c :!for s in $(seq 1 15); do echo; done;sbt compile<cr>

iabbrev reponse    response
iabbrev shfit      shift
iabbrev sfhit      shift

nnor yH y^
nnor yL y$

"""" FUNCTIONS

function! <SID>StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nmap <silent> <Leader><space> :call <SID>StripTrailingWhitespace()<CR>

set wildignore+=*.o,*.obj,.git,*.class,*.jar,*.zip,node_modules/**

nnoremap <leader>t :FZF<cr>

hi link coffeeSpaceError NONE

highlight Normal ctermfg=grey ctermbg=black

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let g:UltiSnipsSnippetDirectories=[$ULTISNIPS_DIR, "UltiSnips"]

let g:ycm_confirm_extra_conf = 0
let g:ycm_server_use_vim_stdout = 1
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'

nnoremap <Leader>d :YcmCompleter GoToDefinitionElseDeclaration<cr>

" Q is my second leader because nuts to ex mode
nnoremap Qs :UltiSnipsEdit<cr>
nnoremap Qv :e ~/.vimrc<cr>
nnoremap QQ :bd!

if s:on_work_machine
    autocmd FileType ruby,eruby,html,haml,coffee,python set ts=4 sw=4 sts=4
endif

"let g:syntastic_python_checkers = ['python']
