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

filetype plugin indent off

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

" let NeoBundle manage NeoBundle
NeoBundle 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'anyakichi/vim-surround.git'
NeoBundle 'gregsexton/gitv.git'
NeoBundle 'h1mesuke/unite-outline.git'
NeoBundle 'h1mesuke/vim-alignta.git'
NeoBundle 'kana/vim-smartchr.git'
NeoBundle 'LeafCage/foldCC.git'
NeoBundle 'mrtazz/DoxygenToolkit.vim.git'
NeoBundle 'Rip-Rip/clang_complete.git'
NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/neocomplcache-clang_complete'
NeoBundle 'Shougo/neocomplcache-snippets-complete.git'
NeoBundle 'Shougo/unite-build.git'
NeoBundle 'Shougo/unite.vim.git'
NeoBundle 'Shougo/unite-ssh.git'
NeoBundle 'Shougo/vim-vcs.git'
NeoBundle 'Shougo/vimfiler.git'
NeoBundle 'Shougo/vimproc.git'
NeoBundle 'Shougo/vimshell.git'
NeoBundle 'Shougo/vinarise.git'
NeoBundle 'thinca/vim-quickrun.git'
NeoBundle 'thinca/vim-ref.git'
NeoBundle 'tpope/vim-fugitive.git'
NeoBundle 'tsukkee/unite-help.git'
NeoBundle 'tsukkee/unite-tag.git'
NeoBundle 'tyru/open-browser.vim.git'
NeoBundle 'ujihisa/vimshell-ssh.git'
NeoBundle 'othree/eregex.vim.git'
NeoBundle 'vim-ruby/vim-ruby.git'
NeoBundle 'vim-scripts/gtags.vim.git'
NeoBundle 'vim-scripts/taglist.vim.git'
NeoBundle 'yuratomo/w3m.vim'
" From vim.org
NeoBundle 'SudoEdit.vim'

"---------------------------------------------------------------------------
" Encoding:"{{{
"
" The automatic recognition of the character code.

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
set encoding=utf-8

" Setting of terminal encoding."{{{
if !has('gui_running')
  if &term == 'win32' || &term == 'win64'
    " Setting when use the non-GUI Japanese console.

    " Garbled unless set this.
    set termencoding=cp932
    " Japanese input changes itself unless set this.
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

" When do not include Japanese, use encoding for fileencoding.
function! AU_ReCheck_FENC() "{{{
  if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
    let &fileencoding=&encoding
  endif
endfunction"}}}

autocmd BufReadPost * call AU_ReCheck_FENC()

" Default fileformat.
set fileformat=unix
" Automatic recognition of a new line cord.
set fileformats=unix,dos,mac
" A fullwidth character is displayed in vim properly.
set ambiwidth=double

" Command group opening with a specific character code again."{{{
" In particular effective when I am garbled in a terminal.
" Open in UTF-8 again.
command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
" Open in iso-2022-jp again.
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
" Open in Shift_JIS again.
command! -bang -bar -complete=file -nargs=? Cp932 edit<bang> ++enc=cp932 <args>
" Open in EUC-jp again.
command! -bang -bar -complete=file -nargs=? Euc edit<bang> ++enc=euc-jp <args>
" Open in UTF-16 again.
command! -bang -bar -complete=file -nargs=? Utf16 edit<bang> ++enc=ucs-2le <args>
" Open in UTF-16BE again.
command! -bang -bar -complete=file -nargs=? Utf16be edit<bang> ++enc=ucs-2 <args>

" Aliases.
command! -bang -bar -complete=file -nargs=? Jis  Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis  Cp932<bang> <args>
command! -bang -bar -complete=file -nargs=? Unicode Utf16<bang> <args>
"}}}

" Tried to make a file note version."{{{
" Don't save it because dangerous.
command! WUtf8 setlocal fenc=utf-8
command! WIso2022jp setlocal fenc=iso-2022-jp
command! WCp932 setlocal fenc=cp932
command! WEuc setlocal fenc=euc-jp
command! WUtf16 setlocal fenc=ucs-2le
command! WUtf16be setlocal fenc=ucs-2
" Aliases.
command! WJis  WIso2022jp
command! WSjis  WCp932
command! WUnicode WUtf16
"}}}

" Handle it in nkf and open.
command! Nkf !nkf -g %

" Appoint a line feed."{{{
command! -bang -bar -complete=file -nargs=? Unix edit<bang> ++fileformat=unix <args>
command! -bang -bar -complete=file -nargs=? Mac edit<bang> ++fileformat=mac <args>
command! -bang -bar -complete=file -nargs=? Dos edit<bang> ++fileformat=dos <args>
command! -bang -complete=file -nargs=? WUnix write<bang> ++fileformat=unix <args> | edit <args>
command! -bang -complete=file -nargs=? WMac write<bang> ++fileformat=mac <args> | edit <args>
command! -bang -complete=file -nargs=? WDos write<bang> ++fileformat=dos <args> | edit <args>
"}}}

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif
"}}}

"---------------------------------------------------------------------------
" Search:"{{{
"
" Ignore the case of normal letters.
set ignorecase
" If the search pattern contains upper case characters, override ignorecase option.
set smartcase
"}}}

"---------------------------------------------------------------------------
" Edit:"{{{
"
" Smart insert tab setting.
set smarttab
" Exchange tab to spaces.
set expandtab
" Substitute <Tab> with blanks.
set tabstop=4
" Spaces instead <Tab>.
set softtabstop=4
" Autoindent width.
set shiftwidth=4
" Round indent by shiftwidth.
set shiftround

" Enable modeline.
set modeline

" Use clipboard register.
set clipboard& clipboard+=unnamed

" Enable backspace delete indent and newline.
set backspace=indent,eol,start

" Highlight parenthesis.
set showmatch

" Display another buffer even if current buffer isn't saved.
set hidden

" Ignore case on insert completion.
set infercase

" Enable folding.
set foldenable
set foldmethod=marker
" Show folding level.
set foldcolumn=3
set fillchars=vert:\|
set commentstring=%s

if exists('*FoldCCtext')
  " Use FoldCCtext().
  set foldtext=FoldCCtext()
  autocmd FileType *
        \   if &filetype !=# 'help'
        \ |   setlocal foldtext=FoldCCtext()
        \ | endif
endif

" Set tags file.
" Don't search tags file in current directory. And search upward.
set tags& tags-=tags tags+=./tags;

" Set cindent.
set cindent

" Set backupdir.
set backupdir=~/.vim/tmp
let &directory = &backupdir
"}}}

"---------------------------------------------------------------------------
" View:"{{{
"
" Show line number.
set number
set numberwidth=6
" Show <TAB> and <CR>
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<
" Wrap long line.
set wrap
" Wrap conditions.
set whichwrap+=h,l,<,>,[,],b,s,~
" Always display statusline.
set laststatus=2
" Set statusline.
set statusline=%<%m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %f%=%{fugitive#statusline()}\ \ %l/%L,%c%V%5P
" Set tabline.
set showtabline=2
" Set visualbell.
set visualbell

" Enable spell check.
set spelllang=en_us

" Completion setting.
set completeopt=menuone
" Completion setting.
" Don't complete from other buffer.
set complete=.
"}}}

"---------------------------------------------------------------------------
" Syntax:"{{{
"
" Enable smart indent.
set smartindent

" Close help and git window by pressing q.
autocmd FileType help,quickrun,ref
      \ nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>
autocmd FileType * if (&readonly || !&modifiable) && !hasmapto('q', 'n')
      \ | nnoremap <buffer><silent> q :<C-u>call <sid>smart_close()<CR>| endif

autocmd FileType c,cpp setlocal foldmethod=syntax

" Enable omni completion.
autocmd FileType c setlocal omnifunc=ccomplete#Complete
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

autocmd FileType python,ruby setlocal foldmethod=indent
"}}}

"---------------------------------------------------------------------------
" Plugin:"{{{
"
" surround.vim"{{{
let g:surround_no_mappings = 1
autocmd FileType * call s:define_surround_keymappings()

function! s:define_surround_keymappings()
  if !&modifiable
    return
  endif

  nmap <buffer> ds  <Plug>Dsurround
  nmap <buffer> cs  <Plug>Csurround
  nmap <buffer> ys  <Plug>Ysurround
  nmap <buffer> yS  <Plug>YSurround
  nmap <buffer> yss <Plug>Yssurround
  nmap <buffer> ySs <Plug>YSsurround
  nmap <buffer> ySS <Plug>YSsurround
endfunction
"}}}

" alignta.vim"{{{
xnoremap <silent> <C-a> :Alignta = /* */<CR>
"}}}

" smartchr.vim"{{{
inoremap <expr> , smartchr#one_of(', ', ',')
inoremap <expr> ? smartchr#one_of(' ? ', '?')

" Smart =.
inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
      \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
      \ : smartchr#one_of(' = ', '=', ' == ')
" Substitute .. into -> .
autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
autocmd FileType vim inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..', '...')
"}}}

" DoxygenToolkit.vim"{{{
nnoremap <silent> [Space]x :<C-u>Dox<CR>
let g:load_doxygen_syntax = 1
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
let g:clang_complete_auto = 1
let g:clang_use_library = 1
let g:clang_auto_select = 1
if s:is_windows
  let g:clang_library_path = 'c:/MinGW/msys/1.0/lib'
endif

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell/command-history'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns.default = '\h\w*'

" Plugin key-mappings.
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

let g:neocomplcache_snippets_dir = '~/.vim/snippets'

" <CR>: close popup and save indent.
inoremap <expr><CR> neocomplcache#close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()

" AutoComplPop like behavior.
let g:neocomplcache_enable_auto_select = 1

let g:neocomplcache_omni_functions = {
    \ 'python' : 'pythoncomplete#Complete',
    \ 'ruby' : 'rubycomplete#Complete',
    \ }

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
"}}}

" unite.vim"{{{
" The prefix key.
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>
nmap f [unite]
xmap f [unite]

nnoremap <expr><silent> [unite]b <SID>unite_build()
function! s:unite_build()
  return ":\<C-u>Unite -buffer-name=build" . tabpagenr() . " -no-quit build\<CR>"
endfunction
nnoremap <silent> [unite]c :<C-u>Unite change<CR>
nnoremap <silent> [unite]d :<C-u>Unite -buffer-name=files -default-action=lcd directory_mru<CR>
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]j :<C-u>Unite jump<CR>
nnoremap <silent> [unite]m :<C-u>Unite mapping<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline -start-insert<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register history/yank<CR>
nnoremap <silent> [unite]s :<C-u>Unite source<CR>
nnoremap <silent> [unite]u :<C-u>Unite buffer file_mru bookmark<CR>

nnoremap <silent> [unite]g :<C-u>Unite grep:. -buffer-name=search -no-quit<CR>
nnoremap <silent> [unite]G :call Cursor_Grep()<CR>
xnoremap <silent> [unite]G :call Visual_Grep()<CR>
function! Cursor_Grep()
  let w = expand('<cword>')
  execute ":tabnew"
  execute ":Unite grep:.::" . w . " -buffer-name=search -no-quit<CR>"
endfunction
function! Visual_Grep()
  let tmp = @@
  silent normal gvy
  let selected = @@
  let @@ = tmp
  execute ":tabnew"
  execute ":Unite grep:.::" . selected . " -buffer-name=search -no-quit<CR>"
endfunction
nnoremap <silent> [Space]b :<C-u>UniteBookmarkAdd<CR>

" Keymapping in unite.vim.
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  " Delete a path upward.
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " Hide the window in hitting ESC key twice.
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction"}}}

" t: tags-and-searches "{{{
" The prefix key.
nnoremap [Tag] <Nop>
nmap t [Tag]
" Jump.
nnoremap [Tag]t  <C-]>
"nnoremap <silent><expr> [Tag]t  &filetype == 'help' ?  "\<C-]>" :
      \ ":\<C-u>UniteWithCursorWord -buffer-name=tag tag tag/include\<CR>"
" Jump next.
nnoremap <silent> [Tag]n :<C-u>tag<CR>
" Jump previous.
nnoremap <silent> [Tag]p  :<C-u>pop<CR>
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
let g:unite_source_grep_default_opts = '-n --include=\*.c --include=\*.cpp --include=\*.h'
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
"}}}

" vimfiler.vim"{{{
nnoremap <silent> <C-g> :<C-u>VimFiler -buffer-name=explorer -simple -toggle<CR>

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0

" Edit file by tabedit.
"let g:vimfiler_edit_action = 'tabopen'
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

autocmd FileType vimfiler call s:vimfiler_my_settings()
function! s:vimfiler_my_settings()"{{{
  " Overwrite settings.
  nnoremap <silent><buffer> J
        \ <C-u>:Unite -buffer-name=files -default-action=lcd directory_mru<CR>

  " Migemo search.
  if !empty(unite#get_filters('matcher_migemo'))
    nnoremap <silent><buffer><expr> /  line('$') > 10000 ?  'g/' :
          \ ":\<C-u>Unite -buffer-name=search -start-insert line_migemo\<CR>"
  endif
endfunction"}}}
"}}}

" vimshell.vim"{{{
nmap <silent> <C-@> :VimShellPop<CR>

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]%p", "(%s)-[%b|%a]%p")'
let g:vimshell_prompt = '% '
let g:vimshell_popup_height = 50

if !s:is_windows
  " Use zsh history.
  let g:vimshell_external_history_path = expand('~/.zsh_history')
endif

" Initialize execute file list.
let g:vimshell_execute_file_list = {}
call vimshell#set_execute_file('txt,vim,c,h,cpp', 'vim')
let g:vimshell_execute_file_list['py'] = 'python'
let g:vimshell_execute_file_list['rb'] = 'ruby'

autocmd FileType vimshell call s:vimshell_my_settings()
function! s:vimshell_my_settings()"{{{
  " Hide the window in hitting ESC key twice.
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q

  call vimshell#set_alias('ll', 'ls -l --encoding=utf-8')
  call vimshell#set_alias('la', 'ls -alF --encoding=utf-8')
  call vimshell#set_alias('l', 'ls -CF')
  call vimshell#set_alias('l.', 'ls -d .*')
  call vimshell#set_alias('cp', 'cp -i')
  call vimshell#set_alias('rm', 'rm -i')
  call vimshell#set_alias('mv', 'mv -i')
endfunction"}}}
"}}}

" ref.vim"{{{
autocmd FileType ref call s:ref_my_settings()
function! s:ref_my_settings()"{{{
  " Overwrite settings.
  nmap <buffer> [Tag]t  <Plug>(ref-keyword)
  nmap <buffer> [Tag]p  <Plug>(ref-back)
endfunction"}}}
"}}}

" gitv.vim"{{{
nnoremap <silent> [Space]gv :<C-u>Gitv<CR>
nnoremap <silent> [Space]gf :<C-u>Gitv!<CR>
"}}}

" fugitive.vim"{{{
nnoremap <silent> [Space]gd :call Fugitive_Tab("Gdiff")<CR>
nnoremap <silent> [Space]gs :<C-u>Gstatus<CR>
nnoremap <silent> [Space]gl :call Fugitive_Tab("Glog")<CR>
nnoremap <silent> [Space]ga :<C-u>Gwrite<CR>
nnoremap <silent> [Space]gA :<C-u>Gwrite <cfile><CR>
nnoremap <silent> [Space]gc :<C-u>Gcommit<CR>
nnoremap <silent> [Space]gC :<C-u>Gcommit --amend<CR>
nnoremap <silent> [Space]gb :call Fugitive_Tab("Gblame")<CR>
function! Fugitive_Tab(cmd)
  execute ":tabnew " . expand("%:p")
  execute a:cmd
endfunction
"}}}

" open-browser.vim"{{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
"}}}

" gtags.vim"{{{
nnoremap <C-j> :<C-u>GtagsCursor<CR>
nnoremap <C-s> :<C-u>Gtags -r
"}}}

" taglist.vim"{{{
if has('mac')
  let Tlist_Ctags_Cmd = '/Applications/MacVim.app/Contents/MacOS/ctags'
elseif s:is_windows
  let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
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
else
  let g:w3m#external_browser = 'chrome'
endif
let g:w3m#search_engine = 
    \ 'https://www.google.co.jp/search?aq=f&ix=seb&sourceid=chrome&ie=' . &encoding . '&q='
autocmd FileType w3m call s:w3m_settings()
function! s:w3m_settings()
  nnoremap <buffer> H :<C-u>call w3m#Back()<CR>
  nnoremap <buffer> L :<C-u>call w3m#Forward()<CR>
  nnoremap <buffer> E :<C-u>W3mShowExtenalBrowser<CR>
  nnoremap <buffer> Q :<C-u>W3mClose<CR>
endfunction
"}}}
"}}}

"---------------------------------------------------------------------------
" Key-mappings: "{{{
"
" Item select mappings
nnoremap <C-n> :<C-u>cn<CR>
nnoremap <C-p> :<C-u>cp<CR>

" [Space]: Other useful commands "{{{
" Smart space mapping.
" Notice: when starting other <Space> mappings in noremap, disappeared [Space].
nmap <Space> [Space]
xmap <Space> [Space]
nnoremap [Space] <Nop>
xnoremap [Space] <Nop>

" Useful save mappings."{{{
nnoremap <silent> [Space]w  :<C-u>update<CR>
nnoremap <silent> [Space]fw :<C-u>write!<CR>
nnoremap <silent> [Space]q  :<C-u>quit<CR>
nnoremap <silent> [Space]aq :<C-u>quitall<CR>
nnoremap <silent> [Space]fq :<C-u>quitall!<CR>
nnoremap <Leader><Leader>   :<C-u>update<CR>
"}}}

" Change tab width. "{{{
nnoremap <silent> [Space]t2 :<C-u>setl shiftwidth=2 softtabstop=2<CR>
nnoremap <silent> [Space]t4 :<C-u>setl shiftwidth=4 softtabstop=4<CR>
"}}}
"}}}

function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction

" <C-t>: Tab pages"{{{
"
" The prefix key.
nmap <C-t> [Tabbed]
nnoremap [Tabbed] <Nop>
" Create tab page.
"nnoremap <silent> [Tabbed]c :<C-u>tabnew<CR>
nnoremap <silent> [Tabbed]c :<C-u>VimFilerTab -buffer-name=explorer -simple -toggle<CR>
nnoremap <silent> [Tabbed]C :<C-u>tabnew %<CR>
nnoremap <silent> [Tabbed]d :<C-u>tabclose<CR>
" Move to other tab page.
nnoremap <silent> [Tabbed]l :<C-u>tabnext<CR>
nnoremap <silent> [Tabbed]h :<C-u>tabprevious<CR>
nnoremap <silent> [Tabbed]H :<C-u>tabfirst<CR>
nnoremap <silent> [Tabbed]L :<C-u>tablast<CR>
nnoremap <silent> [Tabbed]<C-t> :<C-u>Unite tab<CR>
"}}}

" Auto escape / substitute.
xnoremap s y:%s/<C-r>=substitute(@0, '/', '\\/', 'g')<Return>//g<Left><Left>

" Clear highlight.
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>

" Folding."{{{
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
"}}}

"---------------------------------------------------------------------------
" Platform depends:"{{{
"
if s:is_windows
  set shell=c:/MinGW/msys/1.0/bin/bash
endif
"}}}

"---------------------------------------------------------------------------
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

