" vim:fdm=marker

" Header {{{
"----------------------------------------------------------
" Maintainer: Greg Mcclure
" Version: 1.0 - Sat Jun 18 10:49 p.m. 2010 (?) (*)
" (*) you assume you'll remember the year, but you won't
" Version: 1.1 - Sat Jul 20 2:56 p.m. PDT 2013
" Version: 1.2 - Sun Mar  2 12:08 p.m. PST 2014
" Version: 1.3 - Sun Jun  2 3:06 p.m. PDT 2019
"
" Ideas taken from:
"   http://amix.dk/vim/vimrc.html
"   http://learnvimscriptthehardway.stevelosh.com/
"----------------------------------------------------------

" }}}

" :: Setup {{{
"----------------------------------------------------------

" turn off vi compatibility for maximum vim goodness
set nocompatible

" Plug.vim
call plug#begin('~/.vim/plugged')

" Bundles
Plug 'altercation/vim-colors-solarized'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'Raimondi/delimitMate'
Plug 'vim-scripts/matchit.zip'
Plug 'bling/vim-airline'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'
Plug 'jszakmeister/vim-togglecursor'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-rails'
Plug 'pangloss/vim-javascript'
Plug 'Lokaltog/vim-easymotion'
Plug 'tomtom/tcomment_vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'mustache/vim-mustache-handlebars'
Plug 'rking/ag.vim'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-oblique'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-repeat'
Plug 'sheerun/vim-polyglot'
Plug 'burnettk/vim-angular'
Plug 'ledger/vim-ledger'
Plug 'liuchengxu/space-vim-dark'
Plug 'wincent/terminus'
Plug 'hrother/offlineimaprc.vim'
Plug 'tpope/vim-liquid'
Plug 'mattn/emmet-vim'
Plug 'vimwiki/vimwiki'
Plug 'glench/vim-jinja2-syntax'
Plug 'digitaltoad/vim-pug'
Plug 'jbgutierrez/vim-babel'
Plug 'junegunn/limelight.vim'
Plug 'morhetz/gruvbox'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug '~/.vim/local'

call plug#end()

" vim should react to filetype
filetype on
filetype plugin on

" NeoBundle
" NeoBundleCheck

" }}}

" :: General {{{
"----------------------------------------------------------

set backspace=start,indent,eol
set clipboard=unnamed
set display+=lastline
set foldcolumn=2
set fileformats="mac,unix,dos"
set foldenable
set foldlevel=99
set foldmethod=manual
set grepformat=%f:%l:%m
set grepprg=/usr/local/bin/ack
set hidden
set history=1000
set ignorecase
set incsearch
set laststatus=2
set linebreak
set modeline
set mouse=a
set number
set pastetoggle=<S-F2>
set path+=**
set relativenumber
set ruler
set scrolloff=2
set shellslash
set shortmess=atI
set showmatch
set splitbelow
set smartcase
set switchbuf=useopen,usetab
set t_Co=256
set termguicolors
set textwidth=0
set novisualbell
set viminfo='20,\"50
set wildmenu
set wildmode=list:longest
set wrapmargin=0
set rtp+=/usr/local/opt/fzf

" }}}

" :: Colors & Fonts {{{
"----------------------------------------------------------

set background=dark
set encoding=utf-8
set termencoding=utf-8
try
  lang en_US
catch
endtry

syntax on

colo space-vim-dark

" Set font
" set gfn=Source\ Code\ Pro\ for\ Powerline:h18
set gfn=monofur\ for\ Powerline:h23
" set gfn=Fira\ Mono\ for\ Powerline:h20
" set gfn=APL385\ Unicode:h21
" set gfn=Hack:h20

" }}}

" :: Files, Backups, & Undo {{{
"----------------------------------------------------------

" vim flotsam
set backup
set bdir=~/.vim/backups
set directory=~/.vim/swapfiles

" vimball handling
let g:vimball_home = '/Users/gmcclure/.vim/vimballs'

try
  set undodir=~/.vim/undos
  set undofile
catch
endtry

" }}}

" :: Motion, Tabs, & Buffers {{{
"----------------------------------------------------------
let mapleader=','
let g:mapleader=','

" reverse character search
nnoremap <leader>, ,

" rspec, tests from term vim to tmux pane
" config taken from thoughtbot blog post
" http://robots.thoughtbot.com/running-specs-from-vim-sent-to-tmux-via-tslime
nnoremap <leader>st :call RunCurrentSpecFile()<cr>
nnoremap <leader>sn :call RunNearestSpec()<cr>
nnoremap <leader>sl :call RunLastSpec()<cr>
nnoremap <leader>sa :call RunAllSpecs()<cr>

" tab configuration
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>te :tabe
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tm :tabm

" move buffer to pos 0 -- a common move
nnoremap <leader>t0 :tabm 0<cr>

nnoremap <silent> <M-left> :tabm -1<cr>
nnoremap <silent> <M-right> :tabm +1<cr>

" close all buffers
noremap <leader>ba :1,300 bd!<cr>

" close current buffer
noremap <leader>bd :Bclose<cr>

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

" found at http://www.drbunsen.org/writing-in-vim.html
" modified by GMc on July 20, 2013. in order for par
" to work in formatprg, formatoptions must include the
" 't' option.
func! WordProcessorMode()
  setlocal formatoptions=c1t
  setlocal noexpandtab
  nnoremap j gj
  nnoremap k gk
  setlocal spell spelllang=en_us
  set thesaurus+=/Users/gmcclure/.vim/thesaurus/mthesaur.txt
  set complete+=s
  set formatprg=par\ -w80
  setlocal wrap
  setlocal linebreak
  setlocal textwidth=80
  set filetype=markdown
  echo "Word Processor Mode"
endfunc
com! WP call WordProcessorMode()
" nnoremap <leader>wp :WP<cr>

" }}}

" :: Text, Tabs, & Indents {{{
"----------------------------------------------------------
filetype indent on

set autoindent
set copyindent
set expandtab
set nowrap
set shiftround
set softtabstop=4
set shiftwidth=4
set smartindent
set ts=4

" }}}

" :: UI {{{
"----------------------------------------------------------

" no blinking cursor
set gcr=a:blinkon0
" set gcr+=i:blinkwait0

" currently using togglecursor plugin for the following --
" this is useful to keep, though.
" set the cursor to a vertical line in insert mode and a solid block
" in command mode
" if exists('$TMUX')
"   let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"   let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
" else
"   let &t_SI = "\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"   let &t_EI = "\<Esc>]50;CursorShape=0\x7\<Esc>\\"
" end

" upon hitting escape to change modes,
" send successive move-left and move-right
" commands to immediately redraw the cursor
inoremap <special> <Esc> <Esc>hl

" }}}

" :: Miscellaneous Hacks, Maps, & Remaps {{{
"----------------------------------------------------------

" .vimrc shortcuts
nnoremap <silent> <leader>ev :tabe $MYVIMRC<cr>
nnoremap <silent> <leader>sv :so $MYVIMRC<cr>
nnoremap <silent> <leader>gv :tabe ~/.gvimrc<cr>

" paragraph reformatting
vnoremap Q gq
nnoremap Q gqap

" vert nav key remaps
nnoremap j gj
nnoremap k gk

" keysaver trick
nnoremap ; :
nnoremap <leader>; ;

" command line editing
cnoremap <c-j> <t_kd>
cnoremap <c-k> <t_ku>
cnoremap <c-a> <Home>
cnoremap <c-e> <End>

" blank search highlighting
nnoremap <leader>h :noh<cr>

" convenient shortcut
cabbrev csand cd ~/etc/sandbox

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j
endif

" }}}

" :: Plugin Configs {{{
"----------------------------------------------------------

" delimitmate
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_cr = 2
let g:delimitMate_balance_matchpairs = 1

" easymotion rebinding
let g:EasyMotion_leader_key = '<Leader>e'

" fzf
nmap <leader>l :Files<cr>
nmap <leader>; :Buffers<cr>

" gist
let g:github_user = 'gmcclure'
let g:github_token = '93f23d5f99a188a23412a996609e7a5b'

" goyo
let g:goyo_width = 80

function! s:goyo_enter()
    set textwidth=70
    Limelight
endfunction

function! s:goyo_leave()
    set textwidth=0
    Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" mustache-mode
let g:mustache_abbreviations = 1

" neocomplete
nnoremap <leader>ct :NeoCompleteToggle<cr>
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory = '~/.vim/snippets'

imap <c-k> <Plug>(neosnippet_expand_or_jump)
smap <c-k> <Plug>(neosnippet_expand_or_jump)
xmap <c-k> <Plug>(neosnippet_expand_target)

" supertab-like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" for snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" netrw
let g:netrw_liststyle = 3 " tree-style listing
let g:netrw_list_hide = '^\.'

" numbers
let g:enable_numbers = 0

" rspec
let g:rspec_command = 'call Send_to_Tmux("rspec {spec}\n")'

" airline/powerline
" let g:airline_theme = 'powerlineish'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" togglecursor
let g:togglecursor_default = 'block'
let g:togglecursor_leave = 'underline'

" vimwiki
let g:vimwiki_folding = 'list'
let g:vimwiki_list = [{ 'path': '~/Etc/McWiki/', 'path_html': '~/Etc/McWikiSite/'  }]

" }}}

" :: Autocmd Configs {{{
"----------------------------------------------------------
if has("autocmd")

  "----------------------------------------------------------
  " :: Conf
  "----------------------------------------------------------

  augroup filetype_conf
    autocmd!
    au BufNewFile,BufRead *.conf setf conf
  augroup END

  "----------------------------------------------------------
  " :: CSS
  "----------------------------------------------------------

  augroup filetype_css
    autocmd!
    au FileType css set omnifunc=csscomplete#CompleteCSS
  augroup END

  "----------------------------------------------------------
  " :: Cucumber
  "----------------------------------------------------------

  augroup filetype_cucumber
    autocmd!
    au FileType cucumber set ai sw=2
  augroup END

  "----------------------------------------------------------
  " :: EasyAlign
  "----------------------------------------------------------
  
  au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

  "----------------------------------------------------------
  " :: HTML
  "----------------------------------------------------------

  augroup filetype_html
    autocmd!
    au FileType html set omnifunc=htmlcomplete#CompleteTags
  augroup END

  "----------------------------------------------------------
  " :: Java
  "----------------------------------------------------------

  augroup filetype_java
    au FileType java set ai sw=4 sts=4 ts=4 et
  augroup END

  "----------------------------------------------------------
  " :: Javascript
  "----------------------------------------------------------

  augroup filetype_javascript
    autocmd!
    au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  augroup END

  "----------------------------------------------------------
  " :: Markdown
  "----------------------------------------------------------

  autocmd BufNewFile,BufReadPost *.md set filetype=markdown

  "----------------------------------------------------------
  " :: Python
  "----------------------------------------------------------

  augroup filetype_python
    autocmd!
    let python_highlight_all = 1


    " python
    au FileType python set omnifunc=pythoncomplete#Complete
    au FileType python set ai sw=4 et
  augroup END

  "----------------------------------------------------------
  " :: Ruby
  "----------------------------------------------------------

  augroup filetype_ruby
    autocmd!
    au FileType ruby,eruby set ai sw=2 sts=2 et
  augroup END

  "----------------------------------------------------------
  " :: Vim
  "----------------------------------------------------------

  augroup filetype_vim
    autocmd!
    au FileType vim set ai sw=2 et
  augroup END

  "----------------------------------------------------------
  " :: End Autocmd Configs
  "----------------------------------------------------------
endif

" }}}
