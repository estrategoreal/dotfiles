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

" Set augroup.
augroup MyAutoCmd
  autocmd!
augroup END

filetype off

if has('vim_starting')
  if s:is_windows
    execute 'set runtimepath+=' . expand('~/.vim')
  endif

  if filereadable(expand('~/.vimrc.local'))
    execute 'source' expand('~/.vimrc.local')
  endif

  execute 'set runtimepath+=' . expand('~/.vim/bundle/neobundle.vim')
  call neobundle#rc(expand('~/.vim/bundle/'))
endif

" Let NeoBundle manage NeoBundle
NeoBundle 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'anyakichi/vim-surround'
NeoBundle 'basyura/TweetVim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'gregsexton/gitv'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'LeafCage/foldCC'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'mrtazz/DoxygenToolkit.vim'
NeoBundle 'osyo-manga/unite-quickfix'
NeoBundle 'othree/eregex.vim'
NeoBundle 'Rip-Rip/clang_complete'
NeoBundle 'rhysd/accelerated-jk'
NeoBundle 'Shougo/neocomplcache',
      \ { 'depends' : 'Shougo/neocomplcache-snippets-complete' }
NeoBundle 'Shougo/neocomplcache-clang_complete'
NeoBundle 'Shougo/unite-build'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/unite-ssh'
NeoBundle 'Shougo/vim-vcs'
NeoBundle 'Shougo/vimfiler',
      \ { 'depends' : 'Shougo/unite.vim' }
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vinarise'
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'thinca/vim-ref'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tsukkee/unite-help'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'tyru/caw.vim'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'ujihisa/vimshell-ssh'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'vim-scripts/errormarker.vim'
NeoBundle 'vim-scripts/gtags.vim'
NeoBundle 'vim-scripts/taglist.vim'
NeoBundle 'yuratomo/w3m.vim'

" From vim.org
NeoBundle 'sudo.vim'
NeoBundle 'autofmt'

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
  finish
endif

"-----------------------------------------------------------------------------
" Encoding:"{{{
"
" The automatic recognition of the character code.

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
set encoding=utf-8

" Setting of terminal encoding."{{{
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

" The automatic recognition of the character code."{{{
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
function! AU_ReCheck_FENC()"{{{
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
" Search:"{{{
"
" Ignore case in search patterns.
set ignorecase
" Override ignorecase option if the search pattern contains upper case characters.
set smartcase

" Searches wrap around the end of the file.
set wrapscan
"}}}

"-----------------------------------------------------------------------------
" Edit:"{{{
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

" Use FoldCCtext().
set foldtext=FoldCCtext()
autocmd MyAutoCmd FileType *
      \   if &filetype !=# 'help'
      \ |   setlocal foldtext=FoldCCtext()
      \ | endif

" Use grep.
set grepprg=grep\ -nH

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
" View:"{{{
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
" Syntax:"{{{
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
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
augroup END
"}}}

"-----------------------------------------------------------------------------
" Plugin:"{{{
"
" surround.vim"{{{
let g:surround_no_mappings = 1
autocmd MyAutoCmd FileType * call s:define_surround_keymappings()

function! s:define_surround_keymappings()
  if !&modifiable
    return
  endif

  nmap <buffer> ds  <Plug>Dsurround
  nmap <buffer> cs  <Plug>Csurround
  nmap <buffer> ys  <Plug>Ysurround
  nmap <buffer> yS  <Plug>Ygsurround
  nmap <buffer> yss <Plug>Yssurround
  nmap <buffer> ySs <Plug>Ygssurround
  nmap <buffer> ySS <Plug>Ygssurround
endfunction
"}}}

" TweetVim"{{{
" Start TweetVim.
nnoremap <silent> [unite]e :<C-u>Unite tweetvim<CR>
autocmd MyAutoCmd FileType tweetvim call s:tweetvim_my_settings()
function! s:tweetvim_my_settings()"{{{
  " Open say buffer.
  nnoremap <silent><buffer> s :<C-u>TweetVimSay<CR>
  nnoremap <silent><buffer> q :<C-u>close<CR>
endfunction"}}}

" Complete by neocomplcache.
if !exists('g:neocomplcache_dictionary_filetype_lists')
  let g:neocomplcache_dictionary_filetype_lists = {}
endif
let g:neocomplcache_dictionary_filetype_lists.tweetvim_say =
      \ expand('~/.tweetvim/screen_name')
"}}}

" alignta.vim"{{{
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

" smartchr.vim"{{{
inoremap <expr> , smartchr#one_of(', ', ',')
inoremap <expr> ? smartchr#one_of(' ? ', '?')

" Smart =.
inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
      \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
      \ : smartchr#one_of(' = ', '=', ' == ')
augroup MyAutoCmd
  " Substitute .. into -> .
  autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
  autocmd FileType vim inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..', '...')
augroup END
"}}}

" EasyMotion.vim"{{{
let g:EasyMotion_leader_key = '<Space><Space>'
let g:EasyMotion_keys = 'fdsaghjklwertyuiovbcnm'
"}}}

" DoxygenToolkit.vim"{{{
nnoremap <silent> [Space]x :<C-u>Dox<CR>
let g:load_doxygen_syntax = 1
"}}}

" accelerated-jk"{{{
nmap <silent>j <Plug>(accelerated_jk_gj)
nmap <silent>k <Plug>(accelerated_jk_gk)
"}}}

" neocomplcache.vim"{{{
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 0
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 0
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
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
let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

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

" Plugin key-mappings.
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_jump)
imap <C-s> <Plug>(neocomplcache_start_unite_snippet)

let g:neocomplcache_snippets_dir = $HOME . '/.vim/snippets'

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
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
"}}}

" unite.vim"{{{
" The prefix key.
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>
nmap f [unite]
xmap f [unite]

nnoremap <expr><silent> [unite]b <SID>unite_build()
function! s:unite_build()
  return ':\<C-u>Unite -buffer-name=build' . tabpagenr() . ' -no-quit build\<CR>'
endfunction
nnoremap <silent> [unite]d  :<C-u>Unite -buffer-name=files -default-action=lcd bookmark directory_mru<CR>
nnoremap <silent> [unite]f  :<C-u>UniteWithBufferDir -buffer-name=files file file/new<CR>
nnoremap <silent> [unite]j  :<C-u>Unite change jump<CR>
nnoremap <silent> [unite]ma :<C-u>Unite mapping<CR>
nnoremap <silent> [unite]me :<C-u>Unite output:message<CR>
nnoremap <silent> [unite]o  :<C-u>Unite outline -start-insert<CR>
nnoremap <silent> [unite]q  :<C-u>Unite quickfix -no-quit<CR>
xnoremap <silent> [unite]r  d:<C-u>Unite -buffer-name=register register history/yank<CR>
nnoremap <silent> [unite]s  :<C-u>Unite source<CR>
nnoremap <silent> [unite]t  :<C-u>UniteWithCursorWord -buffer-name=tag tag tag/include<CR>
nnoremap <silent> [unite]u  :<C-u>Unite buffer file_mru bookmark<CR>
nnoremap <silent> [unite]v  :<C-u>Unite -buffer-name=files -no-split file_rec/async:!<CR>
nnoremap <silent> [unite]w  :<C-u>Unite window<CR>

nnoremap <silent> [unite]g  :<C-u>Unite grep:. -buffer-name=search -no-quit<CR>
nnoremap <silent> [unite]G  :<C-u>call <SID>cursor_grep()<CR>
xnoremap <silent> [unite]G  :<C-u>call <SID>visual_grep()<CR>
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
function! s:unite_my_settings()"{{{
  " Delete a path upward.
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
endfunction"}}}

" t: tags-and-searches "{{{
" The prefix key.
nnoremap [Tag] <Nop>
nmap t [Tag]
" Jump.
nnoremap [Tag]t <C-]> zv
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
nnoremap <C-h> :<C-u>UniteWithInput help<CR>
" Execute help by cursor keyword.
nnoremap <silent> g<C-h> :<C-u>UniteWithCursorWord help<CR>

let g:unite_source_history_yank_enable = 1

" migemo.
let g:unite_source_alias_aliases = {}
call unite#custom_filters('line_migemo',
      \ ['matcher_migemo', 'sorter_default', 'converter_default'])

let g:unite_enable_start_insert = 0
let g:unite_source_grep_max_candidates = 500

" For ack.
if executable('ack-grep')
  "let g:unite_source_grep_command = 'ack-grep'
  "let g:unite_source_grep_default_opts = '--no-heading --no-color'
  "let g:unite_source_grep_recursive_opt = ''
endif

" For unite-alias.
let g:unite_source_alias_aliases.line_migemo = {
      \ 'source' : 'line',
      \ }

let g:unite_build_error_icon   = expand('~/.vim') . '/signs/err.'
      \ . (s:is_windows ? 'bmp' : 'png')
let g:unite_build_warning_icon = expand('~/.vim') . '/signs/warn.'
      \ . (s:is_windows ? 'bmp' : 'png')
"}}}

" vimfiler.vim"{{{
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
function! s:vimfiler_my_settings()"{{{
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

" vimshell.vim"{{{
nmap <silent> <C-@> <Plug>(vimshell_switch)

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]%p", "(%s)-[%b|%a]%p")'
let g:vimshell_prompt = '% '
let g:vimshell_split_command = ''

if !s:is_windows
  " Use zsh history.
  let g:vimshell_external_history_path = expand('~/.zsh_history')
endif

" Initialize execute file list.
let g:vimshell_execute_file_list = {}
call vimshell#set_execute_file('txt,vim,c,h,cpp', 'vim')
let g:vimshell_execute_file_list['py'] = 'python'
let g:vimshell_execute_file_list['rb'] = 'ruby'

autocmd MyAutoCmd FileType vimshell call s:vimshell_my_settings()
function! s:vimshell_my_settings()"{{{
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

" vinarise.vim"{{{
let g:vinarise_enable_auto_detect = 1
"}}}

" qfreplace.vim"{{{
autocmd MyAutoCmd FileType qf nnoremap <buffer> r :<C-u>Qfreplace<CR>
"}}}

" ref.vim"{{{
autocmd MyAutoCmd FileType ref call s:ref_my_settings()
function! s:ref_my_settings()"{{{
  " Overwrite settings.
  nmap <buffer> [Tag]t <Plug>(ref-keyword)
  nmap <buffer> [Tag]p <Plug>(ref-back)
endfunction"}}}
"}}}

" gitv.vim"{{{
nnoremap <silent> [Space]gv :<C-u>Gitv<CR>
nnoremap <silent> [Space]gf :<C-u>Gitv!<CR>
"}}}

" fugitive.vim"{{{
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

" caw.vim"{{{
nmap gcc <Plug>(caw:i:toggle)
xmap gcc <Plug>(caw:i:toggle)
"}}}

" open-browser.vim"{{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
"}}}

" errormarker.vim"{{{
let errormarker_errortext      = '!!'
let errormarker_warningtext    = '??'
let g:errormarker_errorgroup   = 'Error'
let g:errormarker_warninggroup = 'Todo'
let g:errormarker_erroricon    = expand('~/.vim') . '/signs/err.'
      \ . (s:is_windows ? 'bmp' : 'png')
let g:errormarker_warningicon  = expand('~/.vim') . '/signs/warn.'
      \ . (s:is_windows ? 'bmp' : 'png')
"}}}

" gtags.vim"{{{
nnoremap <C-j> :<C-u>GtagsCursor<CR>
"}}}

" taglist.vim"{{{
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

" w3m.vim"{{{
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
" Key-mappings:"{{{
"
" Command-line mode keymappings:"{{{
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
" Move to other tab page.
nnoremap <silent> [Tabbed]l :<C-u>tabnext<CR>
nnoremap <silent> [Tabbed]h :<C-u>tabprevious<CR>
nnoremap <silent> [Tabbed]H :<C-u>tabfirst<CR>
nnoremap <silent> [Tabbed]L :<C-u>tablast<CR>
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
autocmd QuickFixCmdPost l* lwindow

" For quickfix list "{{{
nnoremap <silent> [Quickfix]n  :<C-u>cnext<CR> zv
nnoremap <silent> [Quickfix]p  :<C-u>cprevious<CR> zv
nnoremap <silent> [Quickfix]r  :<C-u>crewind<CR>
nnoremap <silent> [Quickfix]N  :<C-u>clast<CR>
nnoremap <silent> [Quickfix]P  :<C-u>cfirst<CR>
nnoremap <silent> [Quickfix]fn :<C-u>cnfile<CR>
nnoremap <silent> [Quickfix]fp :<C-u>cpfile<CR>
nnoremap <silent> [Quickfix]l  :<C-u>clist<CR>
nnoremap <silent> [Quickfix]q  :<C-u>cc<CR>
nnoremap <silent> [Quickfix]o  :<C-u>copen<CR>
nnoremap <silent> [Quickfix]c  :<C-u>cclose<CR>
nnoremap <silent> [Quickfix]en :<C-u>cnewer<CR>
nnoremap <silent> [Quickfix]ep :<C-u>colder<CR>
nnoremap <silent> [Quickfix]m  :<C-u>make<CR>
nnoremap [Quickfix]M q:make<Space>
nnoremap [Quickfix]g q:grep<Space>
" Toggle quickfix window.
nnoremap <silent> [Quickfix]<Space> :<C-u>call <SID>toggle_quickfix_window('c')<CR>
function! s:toggle_quickfix_window(type)
  let _ = winnr('$')
  execute a:type == 'c' ? 'cclose' : 'lclose'
  if _ == winnr('$')
    execute a:type == 'c' ? 'botright copen' : 'lopen'
  endif
endfunction
"}}}

" For location list (mnemonic: Quickfix list for the current Window) "{{{
nnoremap <silent> [Quickfix]wn  :<C-u>lnext<CR> zv
nnoremap <silent> [Quickfix]wp  :<C-u>lprevious<CR> zv
nnoremap <silent> [Quickfix]wr  :<C-u>lrewind<CR>
nnoremap <silent> [Quickfix]wN  :<C-u>llast<CR>
nnoremap <silent> [Quickfix]wP  :<C-u>lfirst<CR>
nnoremap <silent> [Quickfix]wfn :<C-u>lnfile<CR>
nnoremap <silent> [Quickfix]wfp :<C-u>lpfile<CR>
nnoremap <silent> [Quickfix]wl  :<C-u>llist<CR>
nnoremap <silent> [Quickfix]wq  :<C-u>ll<CR>
nnoremap <silent> [Quickfix]wo  :<C-u>lopen<CR>
nnoremap <silent> [Quickfix]wc  :<C-u>lclose<CR>
nnoremap <silent> [Quickfix]wen :<C-u>lnewer<CR>
nnoremap <silent> [Quickfix]wep :<C-u>lolder<CR>
nnoremap <silent> [Quickfix]wm  :<C-u>lmake<CR>
nnoremap [Quickfix]wM q:lmake<Space>
nnoremap [Quickfix]wg q:lgrep<Space>
" Toggle quickfix window.
nnoremap <silent> [Quickfix]w<Space> :<C-u>call <SID>toggle_quickfix_window('l')<CR>
"}}}
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

" Auto escape / substitute.
xnoremap s y:%s/<C-r>=substitute(@0, '/', '\\/', 'g')<Return>//g<Left><Left>

" Capitalize a word.
nnoremap gu <ESC>gUiw`]
inoremap <C-q> <ESC>gUiw`]a

" Clear highlight.
nnoremap <silent> <ESC><ESC> :<C-u>nohlsearch<CR>
"}}}

"-----------------------------------------------------------------------------
" Commands:"{{{
"
" Display diff with the file.
command! -nargs=1 -complete=file Diff tabedit % | vertical diffsplit <args>
"}}}

"-----------------------------------------------------------------------------
" Platform depends:"{{{
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
" Others:"{{{
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

