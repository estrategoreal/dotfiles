" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

let s:is_windows = has('win32') || has('win64')
let s:is_msys    = has('win32unix')
let s:is_mac     = has('mac')
let s:is_freebsd = system('uname') =~? "^FreeBSD"

function! IsWindows() abort
  return s:is_windows
endfunction

function! IsMsys() abort
  return s:is_msys
endfunction

function! IsMac() abort
  return s:is_mac
endfunction

function! IsFreeBSD() abort
  return s:is_freebsd
endfunction

" Use English interface.
if IsWindows()
  " For Windows.
  language message en
else
  " For Linux.
  language message C
endif

" Use ',' instead of '\'.
" Use <Leader> in global plugin.
let g:mapleader = ','
" Use <LocalLeader> in filetype plugin.
let g:maplocalleader = 'm'

if IsWindows()
  " Exchange path separator.
  set shellslash
endif

let $CACHE = expand('~/.cache')

if !isdirectory(expand($CACHE))
  call mkdir(expand($CACHE), 'p')
endif

" Because a value is not set in $MYGVIMRC with the console, set it.
if !exists($MYGVIMRC)
  let $MYGVIMRC = expand('~/.gvimrc')
endif

" Set augroup.
augroup MyAutoCmd
  autocmd!
  autocmd FileType,Syntax,BufEnter,BufWinEnter * call s:my_on_filetype()
augroup END

if filereadable(expand('~/.vimrc.local'))
  execute 'source' expand('~/.vimrc.local')
endif

if has('vim_starting') "{{{
  if IsWindows()
    set runtimepath^=$HOME/.vim,$HOME/.vim/after
  endif

  " Load dein.
  let s:dein_dir = finddir('dein.vim', '.;')
  if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
    if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
      let s:dein_dir = expand('$CACHE/dein')
            \. '/repos/github.com/Shougo/dein.vim'

      if !isdirectory(s:dein_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
      endif
    endif

    execute 'set runtimepath^=' . substitute(
          \ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
  endif
endif
"}}}

let g:dein#install_progress_type = 'title'
let g:dein#enable_notification = 1
let g:dein#notification_icon = '~/.vim/signs/warn.png'

let s:path = expand('$CACHE/dein')
if dein#load_state(s:path)
  let s:toml = '~/.vim/rc/dein.toml'
  let s:toml_lazy = '~/.vim/rc/deinlazy.toml'

  call dein#begin(s:path, [expand('<sfile>'), s:toml, s:toml_lazy])

  call dein#load_toml(s:toml, {'lazy' : 0})
  call dein#load_toml(s:toml_lazy, {'lazy' : 1})

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif

if !has('vim_starting')
  call dein#call_hook('source')
  call dein#call_hook('post_source')
endif
"}}}

"-----------------------------------------------------------------------------
" Encoding: "{{{
"
" The automatic recognition of the character code.

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
if has('vim_starting') && &encoding !=# 'utf-8'
  if IsWindows() && has('gui_running')
    set encoding=cp932
  else
    set encoding=utf-8
  endif
endif

" Setting of terminal encoding. "{{{
if !has('gui_running')
  set termencoding=  " same as 'encoding'
elseif IsWindows()
  " For system.
  set termencoding=cp932
endif
"}}}

" The automatic recognition of the character code. "{{{
if !exists('did_encoding_settings') && has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'

  " Does iconv support JIS X 0213?
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213,euc-jp'
    let s:enc_jis = 'iso-2022-jp-3'
  endif

  " Build encodings.
  let &fileencodings = 'ucs-bom'
  if &encoding !=# 'utf-8'
    let &fileencodings .= ',' . 'ucs-2le'
    let &fileencodings .= ',' . 'ucs-2'
  endif
  let &fileencodings .= ',' . s:enc_jis
  let &fileencodings .= ',' . 'utf-8'

  if &encoding ==# 'utf-8'
    let &fileencodings .= ',' . s:enc_euc
    let &fileencodings .= ',' . 'cp932'
  elseif &encoding =~# '^euc-\%(jp\|jisx0213\)$'
    let &encoding = s:enc_euc
    let &fileencodings .= ',' . 'cp932'
    let &fileencodings .= ',' . &encoding
  else  " cp932
    let &fileencodings .= ',' . s:enc_euc
    let &fileencodings .= ',' . &encoding
  endif
  let &fileencodings .= ',' . 'cp20932'

  unlet s:enc_euc
  unlet s:enc_jis

  let did_encoding_settings = 1
endif
"}}}

if has('kaoriya')
  " For Kaoriya only.
  set fileencodings=guess
elseif !exists('did_encoding_settings') && has('iconv')
  " Build encodings.
  let &fileencodings = join([
        \ 'ucs-bom', 'iso-2022-jp-3', 'utf-8', 'euc-jp', 'cp932'])
  let did_encoding_settings = 1
endif

" When any Japanese character is not included, use encoding for fileencoding.
function! s:ReCheck_FENC() abort "{{{
  let is_multi_byte = search("[^\x01-\x7e]", 'n', 100, 100)
  if &fileencoding =~# 'iso-2022-jp' && !is_multi_byte
    let &fileencoding = &encoding
  endif
endfunction"}}}

autocmd MyAutoCmd BufReadPost * call s:ReCheck_FENC()

" The default fileformat.
set fileformat=unix
" Automatic detection of the end-of-line.
set fileformats=unix,dos,mac

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif
"}}}

"-----------------------------------------------------------------------------
" Search: "{{{
"
" Ignore case in search patterns.
set ignorecase
" Override ignorecase option if the search pattern contains upper case characters.
set smartcase

" Searches wrap around the end of the file.
set wrapscan
"}}}

"-----------------------------------------------------------------------------
" Edit: "{{{
"
" Smart insert tab setting.
set smarttab
" Convert tabs to spaces.
set expandtab
" Number of spaces that a <Tab> in the file counts for.
set tabstop=4
" Number of spaces that a <Tab> counts for while performing editing.
set softtabstop=4
" Number of spaces to use for each step of (auto)indent.
set shiftwidth=4
" Round indent to multiple of 'shiftwidth'.
set shiftround

" Enable modeline.
set modeline

" Use the clipboard register.
if (!has('nvim') || $DISPLAY != '') && has('clipboard')
  if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus
  else
    set clipboard& clipboard+=unnamed
  endif
endif

" Highlight the matching bracket.
set showmatch
" Highlight when CursorMoved.
set cpoptions-=m
set matchtime=1
" Highlight <>.
set matchpairs+=<:>

" Display another buffer even if the current buffer isn't saved.
set hidden

" Ignore case in insert completion.
set infercase

" Enable folding.
set foldenable
set foldmethod=marker
" Show fold level.
set foldcolumn=1
set fillchars=vert:\|
set commentstring=%s

if exists('*FoldCCtext')
  " Use FoldCCtext().
  set foldtext=FoldCCtext()
endif

" Use grep.
set grepprg=grep\ -nH

" Reload .vimrc and .gvimrc automatically.
" autocmd MyAutoCmd BufWritePost .vimrc,vimrc source $MYVIMRC | redraw

" Keymapping timeout.
set timeout timeoutlen=3000 ttimeoutlen=100

" CursorHold time.
set updatetime=1000

" Enable automatic C program indenting.
set cindent

" Set a directory for the backup file.
set backupdir=~/.vim/tmp
let &directory = &backupdir

" Set undofile.
set undofile
set undodir=~/.vim/undo

" Enable virtualedit in visual block mode.
set virtualedit=block

" Use autofmt.
set formatexpr=autofmt#japanese#formatexpr()

" Set viminfo.
set viminfo+=n~/.vim/viminfo
"}}}

"-----------------------------------------------------------------------------
" View: "{{{
"
" Print the line number.
set number
set numberwidth=6
" Show tabs and trailing spaces.
set list
if IsWindows()
  set listchars=tab:>-,trail:-,extends:>,precedes:<
else
  set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%
endif
" Always display a status line.
set laststatus=2
" Height of command line.
set cmdheight=2
" Not show command on statusline.
set noshowcmd
" Not show mode.
set noshowmode
" Always display the line with tab page labels.
set showtabline=2
" Set the content of the status line.
set statusline=%<%m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %1.40f%=%{gina#component#repo#branch()}\ \ %l/%L,%c%V%5P

" Turn down a long line appointed in 'breakat'
" set linebreak
" set showbreak=\
" set breakat=\ \	;:,!?
" Wrap conditions.
set whichwrap+=h,l,<,>,[,],b,s,~
" Wrap long lines.
if exists('+breakindent')
  set breakindent
  set wrap
else
  set nowrap
endif

" Do not display greetings message at the time of Vim start.
set shortmess=aTI

" Use visual bell instead of beeping.
set visualbell

" Enable spellchecking.
set spelllang=en_us
" Enable CJK support.
set spelllang+=cjk

" Set options for Insert mode completion.
set completeopt=menuone
" Scan only the current buffer to complete.
set complete=.
" Set the maximum number of items to show in the popup menu.
set pumheight=20

" Report changes.
set report=0

" Maintain a current line at the time of movement as much as possible.
set nostartofline

" Enable fast terminal connection
set ttyfast

" When a line is long, do not omit it in @.
set display=lastline

" Enable multibyte format.
set formatoptions+=mMB

if has('conceal')
  " Set concealing.
  set conceallevel=2 concealcursor=iv
endif
"}}}

"-----------------------------------------------------------------------------
" FileType: "{{{
"
" Enable smart indent.
set smartindent

augroup MyAutoCmd
  autocmd FileType gitcommit,qfreplace setlocal nofoldenable

  " Enable omni completion.
  autocmd FileType c setlocal omnifunc=ccomplete#Complete
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType python setlocal omnifunc=python3complete#Complete
  " autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  autocmd FileType go highlight default link goErr WarningMsg |
        \ match goErr /\<err\>/
augroup END
"}}}

" Python
let g:python_highlight_all = 1

" JavaScript
let g:SimpleJsIndenter_BriefMode = 1
let g:SimpleJsIndenter_CaseIndentLevel = -1

" Go
if $GOROOT != ''
  set runtimepath+=$GOROOT/misc/vim
endif

" Markdown
let g:markdown_fenced_languages = [
      \  'coffee',
      \  'css',
      \  'erb=eruby',
      \  'javascript',
      \  'js=javascript',
      \  'json=javascript',
      \  'ruby',
      \  'sass',
      \  'xml',
      \  'vim',
      \]

function! s:my_on_filetype() abort "{{{
  " Disable automatically insert comment.
  setlocal formatoptions-=ro

  " Use FoldCCtext().
  if &filetype !=# 'help'
    setlocal foldtext=FoldCCtext()
  endif

  if !&l:modifiable
    setlocal nofoldenable
    setlocal foldcolumn=0
    silent! IndentLinesDisable
  endif
endfunction "}}}

"-----------------------------------------------------------------------------
" Key-mappings: "{{{
"
" Visual mode keymappings: "{{{
" <TAB>: indent.
xnoremap <TAB> >
" <S-TAB>: unindent.
xnoremap <S-TAB> <

" Indent
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv

if (!has('nvim') || $DISPLAY != '') && has('clipboard')
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
endif
"}}}

" Command-line mode keymappings: "{{{
" <C-a>: start of line.
cnoremap <C-a> <Home>
" <C-b>: back one character.
cnoremap <C-b> <Left>
" <C-d>: delete character under cursor.
cnoremap <C-d> <Del>
" <C-e>: end of line.
cnoremap <C-e> <End>
" <C-f>: forward one character.
cnoremap <C-f> <Right>
" <C-n>: recall newer command-line.
cnoremap <C-n> <Down>
" <C-p>: recall previous (older) command-line.
cnoremap <C-p> <Up>
" <C-k>: delete to end.
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
" <C-y>: paste.
cnoremap <C-y> <C-r>*
" <C-s>: view history.
cnoremap <C-s> <C-f>
" <C-l>: view completion list.
cnoremap <C-l> <C-d>
" <A-b>: back one word.
cnoremap <A-b> <S-Left>
" <A-f>: forward one word.
cnoremap <A-f> <S-Right>
"}}}

" [Space]: Other useful commands "{{{
" Smart space mapping.
" Notice: when starting other <Space> mappings in noremap, disappear [Space].
nmap <Space> [Space]
xmap <Space> [Space]
nnoremap [Space] <Nop>
xnoremap [Space] <Nop>

" Easily edit .vimrc "{{{
nnoremap <silent> [Space]ve  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> [Space]vr :<C-u>source $MYVIMRC \|
      \ echo "source $MYVIMRC"<CR>
"}}}

" Useful save mappings. "{{{
"nnoremap <silent> <Leader><Leader> :<C-u>update<CR>
nnoremap <silent> [Space]w  :<C-u>update<CR>
nnoremap <silent> [Space]fw :<C-u>write!<CR>
nnoremap <silent> [Space]q  :<C-u>quit<CR>
nnoremap <silent> [Space]aq :<C-u>quitall<CR>
nnoremap <silent> [Space]fq :<C-u>quitall!<CR>
"}}}

" s: Windows and buffers(High priority) "{{{
" The prefix key.
nnoremap [Window] <Nop>
nmap s [Window]
nnoremap <silent> [Window]p :<C-u>vsplit<CR>:wincmd w<CR>
nnoremap <silent> [Window]o :<C-u>only<CR>
nnoremap <silent> <Tab>     :wincmd w<CR>
nnoremap <silent><expr> q winnr('$') != 1 ? ':<C-u>close<CR>' : ""
"}}}
"}}}

" <C-t>: Tab pages "{{{
"
" The prefix key.
nmap <C-t> [Tabbed]
nnoremap [Tabbed] <Nop>
" Create a tab page.
nnoremap <silent> [Tabbed]c :<C-u>call <SID>my_tabnew('')<CR>
nnoremap <silent> [Tabbed]C :<C-u>call <SID>my_tabnew('%')<CR>
nnoremap <silent> [Tabbed]i :<C-u>call <SID>my_idenew()<CR>
nnoremap <silent> [Tabbed]d :<C-u>tabclose<CR>
nnoremap <silent> [Tabbed]<C-t> :<C-u>Unite tab<CR>
nnoremap <silent> [Tabbed]n :<C-u>tabnext<CR>
nnoremap <silent> [Tabbed]p :<C-u>tabprevious<CR>

function! s:my_tabnew(file) abort
  if empty(a:file)
    tabnew
    vsplit
    VimFiler -buffer-name=explorer -toggle
  else
    execute 'tabedit ' . a:file
    vsplit
    wincmd l
    VimFiler -buffer-name=explorer -toggle
  endif
endfunction

function! s:my_idenew() abort
  tabnew
  TagbarOpen
  VimFilerExplorer -winwidth=46
  wincmd l
endfunction
"}}}

" e: Change basic commands "{{{
" The prefix key.
nnoremap [Alt] <Nop>
xnoremap [Alt] <Nop>
nmap e [Alt]
xmap e [Alt]
"}}}

" Disable Ex-mode.
nnoremap Q q

" Disable ZZ.
nnoremap ZZ <Nop>

" Select rectangle.
xnoremap r <C-v>

" Redraw.
nnoremap <silent> <C-l> :<C-u>redraw!<CR>

" q: Quickfix "{{{
" The prefix key.
nnoremap [Quickfix] <Nop>

" Open the quickfix window automatically if it's not empty.
autocmd QuickFixCmdPost [^l]* botright cwindow

" Toggle quickfix window.
nnoremap <silent> [Quickfix]<Space> :<C-u>call <SID>toggle_quickfix_window()<CR>
function! s:toggle_quickfix_window() abort
  let _ = winnr('$')
  cclose
  if _ == winnr('$')
    botright copen
    setlocal nowrap
    setlocal whichwrap=b,s
  endif
endfunction
"}}}

" Folding. "{{{
" If press h on head, fold close.
" nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
" If press l on fold, fold open.
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" If press h on head, range fold close.
" xnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" If press l on fold, range fold open.
xnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'
noremap [Space]j zj
noremap [Space]k zk
noremap [Space]r zR
noremap zu :<C-u>Unite outline:foldings<CR>"{{{"}}}
noremap [Space]z za
"}}}

" Substitute.
xnoremap s :s//g<Left><Left>

" Easy escape. "{{{
inoremap jj <ESC>
cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'

inoremap j<Space> j
"}}}

" a>, i], etc... "{{{
" <angle>
onoremap aa a>
xnoremap aa a>
onoremap ia i>
xnoremap ia i>

" [rectangle]
onoremap ar a]
xnoremap ar a]
onoremap ir i]
xnoremap ir i]

" 'quote'
onoremap aq a'
xnoremap aq a'
onoremap iq i'
xnoremap iq i'

" "double quote"
onoremap ad a"
xnoremap ad a"
onoremap id i"
xnoremap id i"
"}}}

" Move to top/center/bottom.
noremap <expr> zz (winline() == (winheight(0)+1)/ 2) ?
      \ 'zt' : (winline() == 1)? 'zb' : 'zz'

" Capitalize.
nnoremap gu gUiw`]

" Clear highlight.
nnoremap <ESC><ESC> :nohlsearch<CR>:match<CR>
"}}}

"-----------------------------------------------------------------------------
" Commands: "{{{
"
" Display diff with the file.
command! -nargs=1 -complete=file Diff tabedit % | vertical diffsplit <args>

" Input continuous numbers
nnoremap <silent> co :ContinuousNumber <C-a><CR>
vnoremap <silent> co :ContinuousNumber <C-a><CR>
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor

command! -nargs=+ Calc :ruby print <args>
"}}}

"-----------------------------------------------------------------------------
" Platform depends: "{{{
"
if has('nvim')
  tnoremap <ESC>    <C-\><C-n>
  tnoremap jj       <C-\><C-n>
  tnoremap j<Space> j

  nnoremap <Leader>t :<C-u>terminal<CR>
  nnoremap !         :<C-u>terminal<Space>

  " Use cursor shape feature
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

  " Use true color feature
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1

  " Share the histories
  augroup MyAutoCmd
    autocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
  augroup END
endif

" Change colorscheme.
" Don't override colorscheme.
if !exists('g:colors_name') && !has('gui_running')
  colorscheme elflord
endif

set shell=sh
"}}}

"-----------------------------------------------------------------------------
" Others: "{{{
"
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  if has('mouse_sgr')
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  endif
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"}}}

set secure

