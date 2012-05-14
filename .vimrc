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

if has('mac')
  set enc=utf-8 fencs=usc-bom,iso-2022-jp,euc-jp,cp932
elseif has('win32')
  set enc=cp932 fencs=usc-bom,iso-2022-jp,euc-jp,utf-8,utf-16
  set shellslash
  set noignorecase
  if has('gui_running')
    set shell=c:/cygwin/bin/zsh
  endif
else
" enable the line below when editting files on windows
"set enc=cp932 fencs=ucs-bom,iso-2022-jp,euc-jp,utf-8
set enc=utf-8 fencs=ucs-bom,iso-2022-jp,euc-jp,cp932
endif
set visualbell
set number
set numberwidth=6
set cindent
set shiftwidth=4
set tabstop=4
set backupdir=~/.tmp
set showtabline=2
set laststatus=2
set tags& tags-=tags tags+=./tags;
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

nnoremap <C-j> :GtagsCursor<CR>
nnoremap <C-s> :Gtags -r 
nnoremap <C-n> :cn<CR>
nnoremap <C-p> :cp<CR>

nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
nnoremap <C-l> gt
nnoremap <C-h> gT

filetype plugin indent off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc(expand('~/.vim/bundle/'))
endif

" let NeoBundle manage NeoBundle
NeoBundle 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'mileszs/ack.vim'
NeoBundle 'mrtazz/DoxygenToolkit.vim'
NeoBundle 'othree/eregex.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tsaleh/vim-align'
NeoBundle 'vim-scripts/gtags.vim'
NeoBundle 'vim-scripts/sudo.vim'
NeoBundle 'vim-scripts/taglist.vim'

" DoxygenToolkit.vim"{{{
let g:load_doxygen_syntax = 1
"}}}

" neocomplcache.vim"{{{
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" SuperTab like snippets behavior. 
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>" 

let g:neocomplcache_snippets_dir = '~/.vim/snippets'

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"

" AutoComplPop like behavior. 
let g:neocomplcache_enable_auto_select = 1

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
"}}}

" unite.vim"{{{
" Start insert.
let g:unite_enable_start_insert = 1
let g:unite_source_grep_default_opts = '-n --include=\*.c --include=\*.cpp --include=\*.h'

" For ack.
if executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '--no-heading --no-color'
  let g:unite_source_grep_recursive_opt = ''
endif

" Keymap to call in both insert and normal mode.
nnoremap <silent> <C-f> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
inoremap <silent> <C-f> <ESC>:<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <C-b> :<C-u>Unite buffer file_mru<CR>
inoremap <silent> <C-b> <ESC>:<C-u>Unite buffer file_mru<CR>

nnoremap <silent> <C-g> :<C-u>Unite grep:. -buffer-name=search -no-quit<CR>
inoremap <silent> <C-g> <ESC>:<C-u>Unite grep:. -buffer-name=search -no-quit<CR>

" Keymapping in unite.vim.
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  " Delete a path upward.
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " Hide the window in hitting ESC key twice.
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction"}}}
"}}}

" vimfiler.vim"{{{
nnoremap <silent> <C-i> :VimFiler -buffer-name=explorer -simple -toggle<CR>
nnoremap <silent> <S-t> :VimFilerTab -buffer-name=explorer -simple -toggle<CR>

" Edit file by tabedit.
"let g:vimfiler_edit_action = 'tabopen'
if has('win32')
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
"}}}

" vimshell.vim"{{{
nmap <silent> <C-@> :VimShellPop<CR>

let g:vimshell_prompt = '% '
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
autocmd FileType vimshell
\ call vimshell#set_alias('ll', 'ls -l --encoding=utf-8')
\| call vimshell#set_alias('la', 'ls -alF --encoding=utf-8')
\| call vimshell#set_alias('l', 'ls -CF')
\| call vimshell#set_alias('l.', 'ls -d .*')
\| call vimshell#set_alias('cp', 'cp -i')
\| call vimshell#set_alias('rm', 'rm -i')
\| call vimshell#set_alias('mv', 'mv -i')

autocmd FileType vimshell call s:vimshell_my_settings()
function! s:vimshell_my_settings()"{{{
  " Hide the window in hitting ESC key twice.
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
endfunction"}}}
"}}}

" taglist.vim"{{{
if has('mac')
  let Tlist_Ctags_Cmd = '/Applications/MacVim.app/Contents/MacOS/ctags'
else
  let Tlist_Ctags_Cmd = '/usr/bin/ctags'
endif
if has('gui_running')
  let Tlist_Close_On_Select = 1
  let Tlist_Exit_OnlyWindow = 1
  let Tlist_GainFocus_On_ToggleOpen = 1
  let Tlist_Show_One_File = 1
  let Tlist_Use_Right_Window = 1
endif

nnoremap <silent> <C-k> :TlistToggle<CR>
"}}}

let &directory = &backupdir

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
  autocmd FileType c,cpp setlocal expandtab omnifunc=ccomplete#Complete
  autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2

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
