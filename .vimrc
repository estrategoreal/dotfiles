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
let s:is_freebsd = system('uname') == "FreeBSD\n"

" Use English interface.
if s:is_windows
  " For Windows.
  language message en
else
  " For Linux.
  language mes C
endif

if s:is_windows
  " Exchange path separator.
  set shellslash
endif

" Because a value is not set in $MYGVIMRC with the console, set it.
if !exists($MYGVIMRC)
  let $MYGVIMRC = expand('~/.gvimrc')
endif

" Set augroup.
augroup MyAutoCmd
  autocmd!
augroup END

if has('vim_starting')
  if s:is_windows
    execute 'set runtimepath+=' . expand('~/.vim')
  endif

  execute 'set runtimepath+=' . expand('~/.vim/bundle/neobundle.vim')

  if filereadable(expand('~/.vimrc.local'))
    execute 'source' expand('~/.vimrc.local')
  endif
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" neobundle.vim "{{{
" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'anyakichi/vim-surround', '', 'same'
NeoBundleLazy 'basyura/TweetVim', { 'depends' :
      \ ['basyura/twibill.vim', 'tyru/open-browser.vim'],
      \ 'autoload' : { 'commands' : 'TweetVimHomeTimeline' }}
NeoBundleLazy 'davidhalter/jedi-vim', {
      \ 'autoload' : {
      \     'filetypes' : ['python', 'python3'],
      \    },
      \ }
NeoBundle 'gregsexton/gitv'
NeoBundle 'h1mesuke/unite-outline', '', 'same'
NeoBundle 'h1mesuke/vim-alignta', '', 'same'
NeoBundleLazy 'hrsh7th/vim-versions', {
      \ 'autoload' : {
      \     'functions' : 'versions#info', 'commands' : 'UniteVersions'
      \    },
      \ }
NeoBundle 'kana/vim-smartchr', '', 'same', { 'autoload' : {
      \ 'insert' : 1,
      \ }}
NeoBundle 'mrtazz/DoxygenToolkit.vim', '', 'same'
NeoBundle 'osyo-manga/unite-quickfix', '', 'same'
NeoBundle 'othree/eregex.vim', '', 'same'
NeoBundleLazy 'Rip-Rip/clang_complete', {
      \ 'autoload' : {
      \     'filetypes' : ['c', 'cpp'],
      \    },
      \ }
NeoBundle 'rhysd/accelerated-jk'
NeoBundleLazy 'Shougo/foldCC', '', 'same',
      \  { 'autoload' : { 'filetypes' : 'vim' }}
NeoBundle 'Shougo/neocomplcache'
call neobundle#config('neocomplcache', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \   'insert' : 1,
      \ }})
NeoBundle 'Shougo/neobundle-vim-scripts'
NeoBundle 'Shougo/neocomplcache-clang_complete'
NeoBundle 'Shougo/neosnippet'
call neobundle#config('neosnippet', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \   'insert' : 1,
      \ }})
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-build'
NeoBundle 'Shougo/unite-ssh'
NeoBundle 'Shougo/unite-sudo'
NeoBundleLazy 'Shougo/vim-vcs', {
      \ 'depends' : 'thinca/vim-openbuf',
      \ 'autoload' : {'functions' : 'vcs#info', 'commands' : 'Vcs'},
      \ }
NeoBundle 'Shougo/vimfiler',
      \ { 'depends' : 'Shougo/unite.vim' }
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/vimshell'
NeoBundleLazy 'Shougo/vinarise', { 'autoload' :
      \  {'commands' : 'Vinarise' }
      \ }
NeoBundleLazy 'sjl/gundo.vim', '', 'same', { 'autoload' : {
      \ 'commands' : 'GundoToggle'
      \ }}
NeoBundleLazy 'thinca/vim-qfreplace', '', 'same', { 'autoload' : {
      \ 'filetypes' : ['unite', 'quickfix']
      \ }}
NeoBundleLazy 'thinca/vim-quickrun', { 'autoload' : {
      \ 'mappings' : '<Plug>(quickrun)'
      \ }}
NeoBundleLazy 'thinca/vim-ref', { 'autoload' : {
      \ 'commands' : 'Ref'
      \ }}
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tsukkee/unite-help', '', 'same'
NeoBundle 'tsukkee/unite-tag', '', 'same'
NeoBundleLazy 'tyru/caw.vim', { 'autoload' : {
      \ 'mappings' : [
      \   '<Plug>(caw:prefix)', '<Plug>(caw:i:toggle)']
      \ }}
NeoBundleLazy 'tyru/open-browser.vim', '', 'same', { 'autoload' : {
      \ 'mappings' : '<Plug>(openbrowser-smart-search)',
      \ }}
NeoBundleLazy 'ujihisa/vimshell-ssh', { 'autoload' : {
      \ 'filetypes' : 'vimshell',
      \ }}
NeoBundleLazy 'vim-jp/autofmt', '', 'same', { 'autoload' : {
      \ 'mappings' : [['x', 'gq']],
      \ }}
NeoBundleLazy 'vim-ruby/vim-ruby', { 'autoload' : {
      \ 'mappings' : '<Plug>(ref-keyword)',
      \ 'filetypes' : 'ruby'
      \ }}
NeoBundle 'vim-scripts/gtags.vim', '', 'same'
NeoBundle 'vim-scripts/taglist.vim', '', 'same', { 'type' : 'nosync' }
NeoBundleLazy 'yomi322/vim-gitcomplete', { 'autoload' : {
      \ 'filetype' : 'vimshell'
      \ }}
NeoBundleLazy 'yuratomo/w3m.vim', '', 'same', { 'autoload' : {
      \ 'commands' : 'W3mTab',
      \ }}

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
  finish
endif
"}}}

"-----------------------------------------------------------------------------
" Encoding: "{{{
"
" The automatic recognition of the character code.

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
set encoding=utf-8

" Setting of terminal encoding. "{{{
if !has('gui_running')
  if &term == 'win32' || &term == 'win64'
    " Setting to use the non-GUI Japanese console.

    " Garbled unless this is set.
    set termencoding=cp932
    " Japanese input changes itself unless this is set.
    " Be careful because the automatic recognition of the character code is not possible!
    set encoding=japan
  else
    set termencoding=  " same as 'encoding'
  endif
elseif s:is_windows
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
    let &fileencodings = &fileencodings . ',' . 'ucs-2le'
    let &fileencodings = &fileencodings . ',' . 'ucs-2'
  endif
  let &fileencodings = &fileencodings . ',' . s:enc_jis

  if &encoding ==# 'utf-8'
    let &fileencodings = &fileencodings . ',' . s:enc_euc
    let &fileencodings = &fileencodings . ',' . 'cp932'
  elseif &encoding =~# '^euc-\%(jp\|jisx0213\)$'
    let &encoding = s:enc_euc
    let &fileencodings = &fileencodings . ',' . 'utf-8'
    let &fileencodings = &fileencodings . ',' . 'cp932'
  else  " cp932
    let &fileencodings = &fileencodings . ',' . 'utf-8'
    let &fileencodings = &fileencodings . ',' . s:enc_euc
  endif
  let &fileencodings = &fileencodings . ',' . &encoding

  unlet s:enc_euc
  unlet s:enc_jis

  let did_encoding_settings = 1
endif
"}}}

if has('kaoriya')
  " For Kaoriya only.
  "set fileencodings=guess
endif

" When any Japanese character is not included, use encoding for fileencoding.
function! AU_ReCheck_FENC() "{{{
  if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
    let &fileencoding = &encoding
  endif
endfunction"}}}

autocmd MyAutoCmd BufReadPost * call AU_ReCheck_FENC()

" The default fileformat.
set fileformat=unix
" Automatic detection of the end-of-line.
set fileformats=unix,dos,mac
" Use twice the width of ASCII characters.
set ambiwidth=double

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
if has('unnamedplus')
  set clipboard& clipboard^=unnamedplus
else
  set clipboard& clipboard^=unnamed
endif

" Highlight the matching bracket.
set showmatch

" Display another buffer even if the current buffer isn't saved.
set hidden

" Ignore case in insert completion.
set infercase

" Enable folding.
set foldenable
set foldmethod=marker
" Show fold level.
set foldcolumn=3
set fillchars=vert:\|
set commentstring=%s

if exists('*FoldCCtext')
  " Use FoldCCtext().
  set foldtext=FoldCCtext()
  autocmd MyAutoCmd FileType *
        \   if &filetype !=# 'help'
        \ |   setlocal foldtext=FoldCCtext()
        \ | endif
endif

" Use grep.
set grepprg=grep\ -nH

" Keymapping timeout.
set timeout timeoutlen=3000 ttimeoutlen=100

" Set tags files.
" Don't search for tags files in the current directory. And search upward.
set tags& tags-=tags tags+=./tags;

" Enable automatic C program indenting.
set cindent

" Set a directory for the backup file.
set backupdir=~/.vim/tmp
let &directory = &backupdir

" Use autofmt.
set formatexpr=autofmt#japanese#formatexpr()
"}}}

"-----------------------------------------------------------------------------
" View: "{{{
"
" Print the line number.
set number
set numberwidth=6
" Show tabs and trailing spaces.
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<
" Wrap long lines.
set wrap
" Wrap conditions.
set whichwrap+=h,l,<,>,[,],b,s,~
" Always display a status line.
set laststatus=2
" Set the content of the status line.
set statusline=%<%m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %1.40f%=%{fugitive#statusline()}\ \ %l/%L,%c%V%5P
" Always display the line with tab page labels.
set showtabline=2
" Use visual bell instead of beeping.
set visualbell

" Enable spellchecking.
set spelllang=en_us

" Set options for Insert mode completion.
set completeopt=menuone
" Scan only the current buffer to complete.
set complete=.
" Set the maximum number of items to show in the popup menu.
set pumheight=20

" Enable multibyte format.
set formatoptions+=mM

if has('conceal')
  " Set concealing.
  set conceallevel=2 concealcursor=iv
endif
"}}}

"-----------------------------------------------------------------------------
" Syntax: "{{{
"
" Enable smart autoindenting.
set smartindent

augroup MyAutoCmd
  " Close help, quickfix, quickrun and reference window by pressing q.
  autocmd FileType help,qf,qfreplace,quickrun,ref
        \ nnoremap <buffer><silent> q :<C-u>call <SID>smart_close()<CR>
  autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
        \ | nnoremap <buffer><silent> q :<C-u>call <SID>smart_close()<CR>| endif

  " Enable omni completion.
  autocmd FileType c setlocal omnifunc=ccomplete#Complete
  "autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
augroup END
"}}}

"-----------------------------------------------------------------------------
" Plugin: "{{{
"
" surround.vim "{{{
let g:surround_no_mappings = 1
autocmd MyAutoCmd FileType * call s:define_surround_keymappings()

function! s:define_surround_keymappings()
  if !&modifiable
    return
  endif

  nmap <buffer> ds  <Plug>Dsurround
  nmap <buffer> cs  <Plug>Csurround
  nmap <buffer> ys  <Plug>Ysurround
  nmap <buffer> yS  <Plug>YSurround
endfunction
"}}}

" TweetVim "{{{
" Start TweetVim.
nnoremap <silent> [unite]e :<C-u>Unite tweetvim<CR>
autocmd MyAutoCmd FileType tweetvim call s:tweetvim_my_settings()
function! s:tweetvim_my_settings() "{{{
  " Open say buffer.
  nnoremap <silent><buffer> s :<C-u>TweetVimSay<CR>
  nnoremap <silent><buffer> q :<C-u>close<CR>
  nmap <silent><buffer> j <Plug>(accelerated_jk_gj)
endfunction"}}}

" Complete by neocomplcache.
if !exists('g:neocomplcache_dictionary_filetype_lists')
  let g:neocomplcache_dictionary_filetype_lists = {}
endif
let g:neocomplcache_dictionary_filetype_lists.tweetvim_say =
      \ expand('~/.tweetvim/screen_name')
"}}}

" jedi-vim "{{{
let g:jedi#auto_initialization = 1
let g:jedi#popup_on_dot = 0
let g:jedi#rename_command = '<leader>R'
autocmd MyAutoCmd FileType python*
      \ NeoBundleSource jedi-vim | let b:did_ftplugin = 1
"}}}

" alignta.vim "{{{
let g:unite_source_alignta_preset_arguments = [
      \ ["Align at '='", '=>\='],
      \ ["Align at '/*' & '*/'",   '<-- /* -> */'  ],
      \ ["Align at '/**<' & '*/'", '<-- /**< -> */'],
      \ ["Align at ':'", '01 :'],
      \ ["Align at '|'", '|'   ],
      \ ["Align at ')'", '0 )' ],
      \ ["Align at ']'", '0 ]' ],
      \ ["Align at '}'", '}'   ],
      \]

xnoremap <silent> [unite]a :<C-u>Unite alignta:arguments<CR>
"}}}

" vim-versions{{{
nnoremap <silent> [Space]gs :<C-u>UniteVersions status:!<CR>

call unite#custom_default_action('versions/git/status', 'commit')
"}}}

" smartchr.vim "{{{
let bundle = neobundle#get('vim-smartchr')
function! bundle.hooks.on_source(bundle)
  inoremap <expr> , smartchr#one_of(', ', ',')
  inoremap <expr> ? smartchr#one_of(' ? ', '?')

  " Smart =.
  inoremap <expr> =
        \ search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
        \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
        \ : smartchr#one_of(' = ', ' == ', '=')
  augroup MyAutoCmd
    " Substitute .. into -> .
    autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
    autocmd FileType vim inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..', '...')
  augroup END
endfunction
"}}}

" DoxygenToolkit.vim "{{{
nnoremap <silent> [Space]x :<C-u>Dox<CR>
let g:load_doxygen_syntax = 1
"}}}

" accelerated-jk "{{{
nmap <silent>j <Plug>(accelerated_jk_gj)
nnoremap gj j
nmap <silent>k <Plug>(accelerated_jk_gk)
nnoremap gk k
"}}}

" neocomplcache.vim "{{{
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1

let bundle = neobundle#get('neocomplcache')
function! bundle.hooks.on_source(bundle)
  " Use smartcase.
  let g:neocomplcache_enable_smart_case = 0
  " Use camel case completion.
  let g:neocomplcache_enable_camel_case_completion = 0
  " Use underbar completion.
  let g:neocomplcache_enable_underbar_completion = 0
  " Use fuzzy completion.
  let g:neocomplcache_enable_fuzzy_completion = 1
  " Set minimum syntax keyword length.
  let g:neocomplcache_min_syntax_length = 3
  " Set auto completion length.
  let g:neocomplcache_auto_completion_start_length = 2
  " Set manual completion length.
  let g:neocomplcache_manual_completion_start_length = 0
  " Set minimum keyword length.
  let g:neocomplcache_min_keyword_length = 3

  " For clang_complete.
  let g:neocomplcache_force_overwrite_completefunc = 1
  let g:clang_auto_select = 0
  let g:clang_complete_auto = 0
  let g:clang_use_library = 1
  if s:is_windows
    let g:clang_library_path = 'c:/MinGW/msys/1.0/lib'
  endif
  if !exists('g:neocomplcache_force_omni_patterns')
    let g:neocomplcache_force_omni_patterns = {}
  endif
  let g:neocomplcache_force_omni_patterns.c =
        \ '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplcache_force_omni_patterns.cpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplcache_force_omni_patterns.objc =
        \ '[^.[:digit:] *\t]\%(\.\|->\)'

  " Define dictionary.
  let g:neocomplcache_dictionary_filetype_lists = {
        \ 'default' : '',
        \ 'vimshell' : $HOME .'/.vimshell/command-history'
        \ }

  " Define keyword.
  if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

  let g:neosnippet#snippets_directory = $HOME . '/.vim/snippets'

  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplcache#smart_close_popup() . "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  neocomplcache#smart_close_popup()."\<C-h>"
  " <C-y>: paste.
  inoremap <expr><C-y> pumvisible() ? neocomplcache#close_popup() : "\<C-r>\""
  " <C-e>: close popup.
  inoremap <expr><C-e> pumvisible() ? neocomplcache#cancel_popup() : "\<End>"

  " AutoComplPop like behavior.
  let g:neocomplcache_enable_auto_select = 1

  let g:neocomplcache_omni_functions = {
        \ 'ruby' : 'rubycomplete#Complete',
        \ }

  " Enable heavy omni completion.
  if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
  endif
  let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
  let g:neocomplcache_force_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
  let g:neocomplcache_force_omni_patterns.python = '[^. \t]\.\w*'
  let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
endfunction
"}}}

" neosnippet.vim"{{{
let bundle = neobundle#get('neosnippet')
function! bundle.hooks.on_source(bundle)
  imap <C-k> <Plug>(neosnippet_expand_or_jump)
  smap <C-k> <Plug>(neosnippet_expand_or_jump)
  xmap <C-k> <Plug>(neosnippet_expand_target)
  imap <C-s> <Plug>(neosnippet_start_unite_snippet)
  xmap <C-l> <Plug>(neosnippet_start_unite_snippet_target)

  " Enable snipMate compatibility feature.
  let g:neosnippet#enable_snipmate_compatibility = 1

  " Plugin key-mappings.
  inoremap <expr><C-g> neocomplcache#undo_completion()
  inoremap <expr><C-l> neocomplcache#complete_common_string()

  " let g:snippets_dir = '~/.vim/snippets/,~/.vim/bundle/snipmate/snippets/'
endfunction
"}}}

" unite.vim "{{{
" The prefix key.
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>
nmap f [unite]
xmap f [unite]

nnoremap <expr><silent> [unite]b <SID>unite_build()
function! s:unite_build()
  return ':\<C-u>Unite -buffer-name=build' . tabpagenr() . ' -no-quit build\<CR>'
endfunction
nnoremap <silent> [unite]d
      \ :<C-u>UniteWithBufferDir -buffer-name=files file file/new<CR>
nnoremap <silent> [unite]f
      \ :<C-u>Unite buffer file_mru bookmark<CR>
nnoremap <silent> [unite]j
      \ :<C-u>Unite change jump<CR>
nnoremap <silent> [unite]o
      \ :<C-u>Unite outline -start-insert<CR>
nnoremap <silent> [unite]r
      \ :<C-u>Unite -buffer-name=register register history/yank<CR>
xnoremap <silent> [unite]r
      \ d:<C-u>Unite -buffer-name=register register history/yank<CR>
nnoremap <silent> [unite]s
      \ :<C-u>Unite source<CR>
nnoremap <silent> [unite]t
      \ :<C-u>UniteWithCursorWord -buffer-name=tag tag tag/include<CR>
nnoremap <silent> [unite]v
      \ :<C-u>Unite -buffer-name=files -no-split -multi-line file_rec/async:!<CR>
nnoremap <silent> [unite]w
      \ :<C-u>Unite window<CR>

nnoremap <silent> [unite]g
      \ :<C-u>Unite grep:. -buffer-name=search -no-quit<CR>
nnoremap <silent> [unite]G
      \ :<C-u>call <SID>cursor_grep()<CR>
xnoremap <silent> [unite]G
      \ :<C-u>call <SID>visual_grep()<CR>
function! s:cursor_grep()
  let w = expand('<cword>')
  call s:my_idenew()
  execute ':Unite grep:.::' . w . ' -buffer-name=search -no-quit<CR>'
endfunction
function! s:visual_grep()
  let tmp = @@
  silent normal gvy
  let selected = @@
  let @@ = tmp
  call s:my_idenew()
  execute ':Unite grep:.::' . selected . ' -buffer-name=search -no-quit<CR>'
endfunction
nnoremap <silent> [Space]b :<C-u>UniteBookmarkAdd<CR>

" Keymapping in unite.vim.
autocmd MyAutoCmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings() "{{{
  " Overwrite settings.
  nmap <buffer> <ESC>   <Plug>(unite_exit)
  imap <buffer> jj      <Plug>(unite_insert_leave)
  imap <buffer> <C-w>   <Plug>(unite_delete_backward_path)

  imap <buffer><expr> j unite#smart_map('j', '')
  imap <buffer> <TAB>   <Plug>(unite_select_next_line)
  imap <buffer> <C-w>   <Plug>(unite_delete_backward_path)
  imap <buffer> '       <Plug>(unite_quick_match_default_action)
  nmap <buffer> '       <Plug>(unite_quick_match_default_action)
  imap <buffer><expr> x
        \ unite#smart_map('x', "\<Plug>(unite_quick_match_choose_action)")
  nmap <buffer> x       <Plug>(unite_quick_match_choose_action)
  nmap <buffer> <C-z>   <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-z>   <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-y>   <Plug>(unite_narrowing_path)
  nmap <buffer> <C-y>   <Plug>(unite_narrowing_path)
  nmap <buffer> <C-j>   <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <C-r>   <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r>   <Plug>(unite_narrowing_input_history)
  nnoremap <silent><buffer><expr> l
        \ unite#smart_map('l', unite#do_action('default'))

  let unite = unite#get_current_unite()
  if unite.buffer_name =~# '^search'
    nnoremap <silent><buffer><expr> r unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r unite#do_action('rename')
  endif

  nnoremap <silent><buffer><expr> cd unite#do_action('lcd')
  nnoremap <buffer><expr> S          unite#mappings#set_current_filters(
        \ empty(unite#mappings#get_current_filters()) ? ['sorter_reverse'] : [])
endfunction"}}}

" t: tags-and-searches "{{{
" The prefix key.
nnoremap [Tag] <Nop>
nmap t [Tag]
" Jump.
nnoremap [Tag]t <C-]> zv zz
"nnoremap <silent><expr> [Tag]t  &filetype == 'help' ?  "\<C-]>" :
      \ ":\<C-u>UniteWithCursorWord -buffer-name=tag -immediately tag tag/include\<CR>"
" Jump next.
nnoremap <silent> [Tag]n :<C-u>tnext<CR>
" Jump previous.
nnoremap <silent> [Tag]p :<C-u>pop<CR>
"nnoremap <silent><expr> [Tag]p  &filetype == 'help' ?
      \ ":\<C-u>pop\<CR>" : ":\<C-u>Unite jump\<CR>"
"}}}

" Execute help.
nnoremap <silent> <C-h> :<C-u>Unite -buffer-name=help help<CR>
" Execute help by cursor keyword.
nnoremap <silent> g<C-h>  :<C-u>help<Space><C-r><C-w><CR>

let g:unite_source_history_yank_enable = 1

" migemo.
call unite#custom_source('line_migemo', 'matchers', 'matcher_migemo')

let g:unite_enable_start_insert = 0
let g:unite_source_grep_max_candidates = 500

" For ack.
if executable('ack-grep')
  "let g:unite_source_grep_command = 'ack-grep'
  "let g:unite_source_grep_default_opts = '--no-heading --no-color -a'
  "let g:unite_source_grep_recursive_opt = ''
endif

" For unite-alias.
let g:unite_source_alias_aliases = {}
let g:unite_source_alias_aliases.line_migemo = {
      \ 'source' : 'line',
      \ }

" For unite-menu.
let g:unite_source_menu_menus = {}

let g:unite_source_menu_menus.unite = {
      \     'description' : 'Start unite sources',
      \ }
let g:unite_source_menu_menus.unite.command_candidates = {
      \ 'directory' : 'Unite -buffer-name=files '.
      \       '-default-action=lcd bookmark directory_mru',
      \ 'history'   : 'Unite history/command',
      \ 'mapping'   : 'Unite mapping',
      \ 'message'   : 'Unite output:message',
      \ 'quickfix'  : 'Unite qflist -no-quit',
      \ 'resume'    : 'Unite -buffer-name=resume resume',
      \ }
nnoremap <silent> [unite]u :<C-u>Unite menu:unite<CR>

let g:unite_build_error_icon   = expand('~/.vim') . '/signs/err.'
      \ . (s:is_windows ? 'bmp' : 'png')
let g:unite_build_warning_icon = expand('~/.vim') . '/signs/warn.'
      \ . (s:is_windows ? 'bmp' : 'png')
"}}}

" vimfiler.vim "{{{
nnoremap <silent> <C-g> :<C-u>VimFiler -buffer-name=explorer -simple -toggle<CR>

let g:vimfiler_as_default_explorer = 1

" Enable file operation commands.
let g:vimfiler_safe_mode_by_default = 0

if s:is_windows
  " Use trashbox.
  let g:unite_kind_file_use_trashbox = 1
else
  " Like Textmate icons.
  let g:vimfiler_tree_leaf_icon = ' '
  let g:vimfiler_tree_opened_icon = '▾'
  let g:vimfiler_tree_closed_icon = '▸'
  let g:vimfiler_file_icon = '-'
  let g:vimfiler_marked_file_icon = '*'
endif

autocmd MyAutoCmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings() "{{{
  " Overwrite settings.
  nnoremap <silent><buffer> J
        \ <C-u>:Unite -buffer-name=files -default-action=lcd directory_mru<CR>

  " Migemo search.
  if !empty(unite#get_filters('matcher_migemo'))
    nnoremap <silent><buffer><expr> / line('$') > 10000 ? 'g/' :
          \ ":\<C-u>Unite -buffer-name=search -start-insert line_migemo\<CR>"
  endif
endfunction"}}}
"}}}

" vimshell.vim "{{{
nmap <silent> <C-@> <Plug>(vimshell_switch)

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]%p", "(%s)-[%b|%a]%p")'
let g:vimshell_prompt = '% '
let g:vimshell_split_command = ''

autocmd MyAutoCmd FileType vimshell call s:vimshell_settings()
function! s:vimshell_settings() "{{{
  if !s:is_windows
    " Use zsh history.
    let g:vimshell_external_history_path = expand('~/.zsh_history')
  endif

  " Initialize execute file list.
  let g:vimshell_execute_file_list = {}
  call vimshell#set_execute_file('txt,vim,c,h,cpp', 'vim')
  let g:vimshell_execute_file_list['py'] = 'python'
  let g:vimshell_execute_file_list['rb'] = 'ruby'

  " Hide the window in hitting ESC key twice.
  nmap <silent><buffer> <ESC><ESC> <C-^>
  imap <silent><buffer> <ESC><ESC> <ESC><C-^>
  imap <buffer><C-k> <Plug>(vimshell_zsh_complete)

  nnoremap <silent><buffer> J
        \ <C-u>:Unite -buffer-name=files -default-action=lcd directory_mru<CR>

  call vimshell#set_alias('ll', 'ls -l')
  call vimshell#set_alias('la', 'ls -alF')
  call vimshell#set_alias('l', 'ls -CF')
  call vimshell#set_alias('l.', 'ls -d .*')
  call vimshell#set_alias('cp', 'cp -i')
  call vimshell#set_alias('rm', 'rm -i')
  call vimshell#set_alias('mv', 'mv -i')
endfunction"}}}
"}}}

" vinarise.vim "{{{
let g:vinarise_enable_auto_detect = 1
"}}}

" Gundo.vim "{{{
nnoremap U :<C-u>GundoToggle<CR>
"}}}

" qfreplace.vim "{{{
autocmd MyAutoCmd FileType qf nnoremap <buffer> r :<C-u>Qfreplace<CR>
"}}}

" ref.vim "{{{
let bundle = neobundle#get('vim-ref')
function! bundle.hooks.on_source(bundle)
  autocmd MyAutoCmd FileType ref call s:ref_my_settings()
  function! s:ref_my_settings() "{{{
    " Overwrite settings.
    nmap <buffer> [Tag]t <Plug>(ref-keyword)
    nmap <buffer> [Tag]p <Plug>(ref-back)
  endfunction"}}}
endfunction
"}}}

" gitv.vim "{{{
nnoremap <silent> [Space]gv :<C-u>Gitv<CR>
nnoremap <silent> [Space]gf :<C-u>Gitv!<CR>
"}}}

" fugitive.vim "{{{
nnoremap <silent> [Space]gd :<C-u>call <SID>fugitive_tab('Gdiff')<CR>
nnoremap <silent> [Space]gs :<C-u>Gstatus<CR>
nnoremap <silent> [Space]gl :<C-u>call <SID>fugitive_tab('Glog')<CR>
nnoremap <silent> [Space]ga :<C-u>Gwrite<CR>
nnoremap <silent> [Space]gA :<C-u>Gwrite %<CR>
nnoremap <silent> [Space]gc :<C-u>Gcommit<CR>
nnoremap <silent> [Space]gC :<C-u>Gcommit --amend<CR>
nnoremap <silent> [Space]gb :<C-u>call <SID>fugitive_tab('Gblame')<CR>
function! s:fugitive_tab(cmd)
  execute 'tabedit ' . expand('%')
  execute a:cmd
endfunction
"}}}

" caw.vim "{{{
nmap gc <Plug>(caw:prefix)
xmap gc <Plug>(caw:prefix)
nmap gcc <Plug>(caw:i:toggle)
xmap gcc <Plug>(caw:i:toggle)
"}}}

" open-browser.vim "{{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
"}}}

" gtags.vim "{{{
nnoremap <C-j> :<C-u>GtagsCursor<CR> zv
nnoremap <silent> <C-n> :<C-u>cnext<CR> zv zz
nnoremap <silent> <C-p> :<C-u>cprevious<CR>
"}}}

" taglist.vim "{{{
if has('mac') || s:is_windows
  let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
elseif s:is_freebsd
  let Tlist_Ctags_Cmd = '/usr/local/bin/exctags'
else
  let Tlist_Ctags_Cmd = '/usr/bin/ctags'
endif
if has('gui_running')
  let Tlist_Exit_OnlyWindow = 1
  let Tlist_GainFocus_On_ToggleOpen = 1
  let Tlist_Show_One_File = 1
  let Tlist_Use_Right_Window = 1
  let Tlist_WinWidth = 42
endif
"}}}

" w3m.vim "{{{
nnoremap W :<C-u>W3mTab<Space>
if has('mac')
  let g:w3m#external_browser = 'open -a "Google Chrome"'
elseif s:is_windows
  let g:w3m#command = 'c:/MinGW/msys/1.0/local/bin/w3m.exe'
  let g:w3m#external_browser = '"'.$USERPROFILE.'/Local Settings/Application Data/Google/Chrome/Application/chrome.exe'.'"'
elseif s:is_freebsd
  let g:w3m#external_browser = 'chrome'
else
  let g:w3m#external_browser = 'chromium'
endif
let g:w3m#search_engine = 'http://www.google.co.jp/search?ie=' . &encoding . '&q='
autocmd MyAutoCmd FileType w3m call s:w3m_settings()
function! s:w3m_settings()
  nnoremap <buffer> H :<C-u>call w3m#Back()<CR>
  nnoremap <buffer> L :<C-u>call w3m#Forward()<CR>
  nnoremap <buffer> E :<C-u>W3mShowExtenalBrowser<CR>
  nnoremap <buffer> Q :<C-u>W3mClose<CR>
endfunction
"}}}
"}}}

"-----------------------------------------------------------------------------
" Key-mappings: "{{{
"
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

" Useful save mappings. "{{{
"nnoremap <silent> <Leader><Leader> :<C-u>update<CR>
nnoremap <silent> [Space]w  :<C-u>update<CR>
nnoremap <silent> [Space]fw :<C-u>write!<CR>
nnoremap <silent> [Space]q  :<C-u>quit<CR>
nnoremap <silent> [Space]aq :<C-u>quitall<CR>
nnoremap <silent> [Space]fq :<C-u>quitall!<CR>
"}}}

" Change tab width. "{{{
nnoremap <silent> [Space]t2 :<C-u>setlocal shiftwidth=2 softtabstop=2<CR>
nnoremap <silent> [Space]t4 :<C-u>setlocal shiftwidth=4 softtabstop=4<CR>
"}}}
"}}}

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction

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

function! s:my_tabnew(file)
  if empty(a:file)
    tabnew
    vsplit
    VimFiler -buffer-name=explorer -simple -toggle
  else
    execute 'tabedit ' . a:file
    vsplit
    wincmd l
    VimFiler -buffer-name=explorer -simple -toggle
  endif
endfunction

function! s:my_idenew()
  tabnew
  TlistOpen
  VimFilerExplorer -winwidth=46
  wincmd l
endfunction
"}}}

" q: Quickfix "{{{
"
" The prefix key.
nnoremap [Quickfix] <Nop>
nmap q [Quickfix]

" Open the quickfix window automatically if it's not empty.
autocmd QuickFixCmdPost [^l]* botright cwindow

" Toggle quickfix window.
nnoremap <silent> [Quickfix]<Space> :<C-u>call <SID>toggle_quickfix_window()<CR>
function! s:toggle_quickfix_window()
  let _ = winnr('$')
  cclose
  if _ == winnr('$')
    botright copen
    setlocal nowrap
    setlocal whichwrap=b,s
  endif
endfunction
"}}}

" Like gv, but select the last changed text.
nnoremap gc `[v`]
" Specify the last changed text as {motion}.
vnoremap <silent> gc :<C-u>normal gc<CR>
onoremap <silent> gc :<C-u>normal gc<CR>

" Folding. "{{{
noremap [Space]n ]z
noremap [Space]p [z
noremap [Space]j zj
noremap [Space]k zk
noremap [Space]h zc
noremap [Space]l zo
noremap [Space]a zA
noremap [Space]m zM
noremap [Space]i zMzv
noremap [Space]r zR
noremap [Space]f zf
noremap [Space]d zd
noremap [Space]u :<C-u>Unite outline:foldings<CR>
noremap [Space]gg :<C-u>echo FoldCCnavi()<CR>
"}}}

" Substitute.
xnoremap s :s//g<Left><Left>

" Easy escape. "{{{
inoremap jj <ESC>
cnoremap <expr> j getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
onoremap jj <ESC>

inoremap j<Space> j
onoremap j<Space> j
"}}}

" Capitalize a word.
nnoremap gu <ESC>gUiw`]
inoremap <C-q> <ESC>gUiw`]a

" Clear highlight.
nnoremap <silent> <ESC><ESC> :<C-u>nohlsearch<CR>
"}}}

"-----------------------------------------------------------------------------
" Commands: "{{{
"
" Display diff with the file.
command! -nargs=1 -complete=file Diff tabedit % | vertical diffsplit <args>
"}}}

"-----------------------------------------------------------------------------
" Platform depends: "{{{
"
" Change colorscheme.
" Don't override colorscheme.
if !exists('g:colors_name') && !has('gui_running')
  colorscheme elflord
endif

if s:is_windows
  set shell=c:/MinGW/msys/1.0/bin/bash
elseif has('win32unix')
  set shell=bash
else
  set shell=zsh
endif
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

