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

" Use English interface.
if s:is_windows
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

if s:is_windows
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

let s:path = expand('$CACHE/dein')
if dein#load_state(s:path)
  let s:toml = '~/.vim/rc/dein.toml'
  let s:toml_lazy = '~/.vim/rc/deinlazy.toml'

  call dein#begin(s:path, [expand('<sfile>'), s:toml, s:toml_lazy])

  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:toml_lazy, {'lazy' : 1})

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif
"}}}

"-----------------------------------------------------------------------------
" Encoding: "{{{
"
" The automatic recognition of the character code.

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
if has('vim_starting') && &encoding !=# 'utf-8'
  if s:is_windows && has('gui_running')
    set encoding=cp932
  else
    set encoding=utf-8
  endif
endif

" Setting of terminal encoding. "{{{
if !has('gui_running')
  set termencoding=  " same as 'encoding'
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
if s:is_windows
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
"set statusline=%<%m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %1.40f%=%{fugitive#statusline()}\ \ %l/%L,%c%V%5P
set statusline=%<%m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %1.40f%=%{gita#statusline#preset('branch')}\ \ %l/%L,%c%V%5P

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
" Plugin: "{{{
"
if dein#tap('sideways.vim') "{{{
  nnoremap <silent> " :SidewaysJumpLeft<CR>
  nnoremap <silent> ' :SidewaysJumpRight<CR>
  omap a, <Plug>SidewaysArgumentTextobjA
  xmap a, <Plug>SidewaysArgumentTextobjA
  omap i, <Plug>SidewaysArgumentTextobjI
  xmap i, <Plug>SidewaysArgumentTextobjI
endif "}}}

if dein#tap('TweetVim') "{{{
  " Start TweetVim.
  nnoremap <silent> [unite]e :<C-u>Unite tweetvim<CR>
  autocmd MyAutoCmd FileType tweetvim call s:tweetvim_my_settings()
  function! s:tweetvim_my_settings() abort "{{{
    " Open say buffer.
    nnoremap <silent><buffer> s :<C-u>TweetVimSay<CR>
    nnoremap <silent><buffer> q :<C-u>close<CR>
    nmap <silent><buffer> j <Plug>(accelerated_jk_gj)
  endfunction"}}}

  let g:tweetvim_display_separator = 0
endif "}}}

if dein#tap('concealedyank.vim') "{{{
  xmap Y <Plug>(operator-concealedyank)
endif "}}}

if dein#tap('jedi-vim') "{{{
  autocmd MyAutoCmd FileType python
        \ if has('python') || has('python3') |
        \   setlocal omnifunc=jedi#completions |
        \ else |
        \   setlocal omnifunc= |
        \ endif
  let g:jedi#completions_enabled = 0
  let g:jedi#auto_vim_configuration = 0
endif "}}}

if dein#tap('vim-easymotion') "{{{
  nmap w <Plug>(easymotion-lineforward)
  nnoremap W w
  nmap b <Plug>(easymotion-linebackward)
  nnoremap B b
  nmap [Alt]j <Plug>(easymotion-j)
  nmap [Alt]k <Plug>(easymotion-k)

  let g:EasyMotion_startofline = 0
  let g:EasyMotion_show_prompt = 0
  let g:EasyMotion_verbose = 0
endif"}}}

if dein#tap('gitv') "{{{
  nnoremap <silent> [Space]gv :<C-u>Gitv<CR>
  nnoremap <silent> [Space]gf :<C-u>Gitv!<CR>
endif "}}}

" if dein#tap('vim-alignta') "{{{
"   let g:unite_source_alignta_preset_arguments = [
"         \ ["Align at '/*' & '*/'", '<-- /* -> */' ],
"         \ ["Align at '='", '=>\='],
"         \ ["Align at ':'", '01 :'],
"         \ ["Align at '|'", '|'   ],
"         \ ["Align at ')'", '0 )' ],
"         \ ["Align at ']'", '0 ]' ],
"         \ ["Align at '}'", '}'   ],
"         \]
"
"   xnoremap <silent> [unite]a :<C-u>Unite alignta:arguments<CR>
" endif "}}}

if dein#tap('vim-operator-flashy') "{{{
  map y <Plug>(operator-flashy)
  nmap Y <Plug>(operator-flashy)$
endif"}}}

if dein#tap('vim-niceblock') "{{{
  xmap I <Plug>(niceblock-I)
  xmap A <Plug>(niceblock-A)
endif "}}}

if dein#tap('vim-easy-align') "{{{
  let g:easy_align_delimiters = {
        \ '>': { 'pattern': '>>\|=>\|>' },
        \ '/': {
        \     'pattern':         '//\+\|/\*\|\*/',
        \     'delimiter_align': 'l',
        \     'ignore_groups':   ['!Comment'] },
        \ ']': {
        \     'pattern':       '[[\]]',
        \     'left_margin':   0,
        \     'right_margin':  0,
        \     'stick_to_left': 0
        \   },
        \ ')': {
        \     'pattern':       '[()]',
        \     'left_margin':   0,
        \     'right_margin':  0,
        \     'stick_to_left': 0
        \   },
        \ 'd': {
        \     'pattern':      ' \(\S\+\s*[;=]\)\@=',
        \     'left_margin':  0,
        \     'right_margin': 0
        \   }
        \ }

  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
  xmap <Enter> <Plug>(EasyAlign)

  " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
  nmap <Leader>a <Plug>(EasyAlign)
endif "}}}

if dein#tap('vim-operator-replace') "{{{
  xmap p <Plug>(operator-replace)
endif "}}}

if dein#tap('vim-smartchr') "{{{
  function! s:smartchr_on_source() abort
    inoremap <expr> , smartchr#one_of(', ', ',')

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
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:smartchr_on_source()'
endif "}}}

if dein#tap('FastFold') "{{{
  " Folding
  let g:tex_fold_enabled = 1

  " Vim script
  " augroup: a
  " function: f
  let g:vimsyn_folding = 'af'

  let g:xml_syntax_folding = 1
  let g:perl_fold = 1
endif "}}}

if dein#tap('vim-findent') "{{{
  augroup findent
    autocmd!
    autocmd BufRead * Findent! --no-warnings
  augroup END
endif "}}}

if dein#tap('vim-gita') "{{{
  nnoremap <silent> [Space]gs :<C-u>Gita status<CR>
  nnoremap <silent> [Space]gc :<C-u>Gita commit<CR>
  nnoremap <silent> [Space]ga :<C-u>Gita commit --amend<CR>
  nnoremap <silent> [Space]gd :<C-u>call <SID>gita_tab('diff')<CR>
  nnoremap <silent> [Space]gb :<C-u>Gita browse<CR>
  nnoremap <silent> [Space]gl :<C-u>Gita blame<CR>

  let gita#features#commit#enable_default_mappings = 0

  function! s:gita_tab(cmd) abort
    if s:is_windows
      setlocal shellpipe=2>\&1\|iconv\ -f\ UTF-8\ -t\ CP932>%s
    endif
    execute 'tabedit ' . expand('%')
    execute 'Gita ' . a:cmd
    if s:is_windows
      setlocal shellpipe&
    endif
  endfunction
endif "}}}

if dein#tap('tagbar') "{{{
  if s:is_windows
    let g:tagbar_ctags_bin = 'C:/msys64/usr/local/bin/ctags'
  elseif s:is_msys || s:is_mac
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
  elseif s:is_freebsd
    let g:tagbar_ctags_bin = '/usr/local/bin/exctags'
  else
    let g:tagbar_ctags_bin = '/usr/bin/ctags'
  endif
  if has('gui_running')
    let g:tabgar_autofocus = 1
    let g:tagbar_width = 42
  endif
endif "}}}

if dein#tap('DoxygenToolkit.vim') "{{{
  nnoremap <silent> [Space]x :<C-u>Dox<CR>
  let g:load_doxygen_syntax = 1
endif "}}}

if dein#tap('vim-jplus') "{{{
  nmap J <Plug>(jplus)
  vmap J <Plug>(jplus)
endif "}}}

if dein#tap('vim-marching') "{{{
  if s:is_windows
    let g:marching_clang_command = "C:/msys64/mingw64/bin/clang.exe"
  endif
  let g:marching_enable_neocomplete = 1
endif "}}}

if dein#tap('vim-textobj-user') "{{{
  omap ab <Plug>(textobj-multiblock-a)
  omap ib <Plug>(textobj-multiblock-i)
  xmap ab <Plug>(textobj-multiblock-a)
  xmap ib <Plug>(textobj-multiblock-i)
endif "}}}

if dein#tap('accelerated-jk') "{{{
  nmap <silent>j <Plug>(accelerated_jk_gj)
  nmap gj j
  nmap <silent>k <Plug>(accelerated_jk_gk)
  nmap gk k
endif "}}}

if dein#tap('vim-operator-surround') "{{{
  nmap <silent>sa <Plug>(operator-surround-append)a
  nmap <silent>sd <Plug>(operator-surround-delete)a
  nmap <silent>sr <Plug>(operator-surround-replace)a
endif "}}}

if dein#tap('glowshi-ft.vim') "{{{
  let g:glowshi_ft_no_default_key_mappings = 1
  map f <Plug>(glowshi-ft-f)
  map F <Plug>(glowshi-ft-F)

  let g:glowshi_ft_timeoutlen = 1000
endif "}}}

if dein#tap('deoplete.vim') && has('nvim') "{{{
  " Use deoplete.
  let g:deoplete#enable_at_startup = 1

  function! s:deoplete_on_source() abort
    " Use smartcase.
    let g:deoplete#enable_smart_case = 1

    set completeopt+=noinsert

    " <TAB>: completion.
    imap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ deoplete#mappings#manual_complete()
    function! s:check_back_space() abort "{{{
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction"}}}

    " <S-TAB>: completion back.
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> deoplete#mappings#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> deoplete#mappings#smart_close_popup()."\<C-h>"

    inoremap <expr><C-g> deoplete#mappings#undo_completion()
    " <C-l>: redraw candidates
    inoremap <expr><C-l> deoplete#mappings#refresh()

    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function() abort
      return deoplete#mappings#close_popup() . "\<CR>"
    endfunction

    inoremap <expr> ' pumvisible() ? deoplete#mappings#close_popup() : "'"

    call deoplete#custom#set('_', 'converters', ['converter_remove_paren'])

    let g:deoplete#keyword_patterns = {}
    let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'

    let g:deoplete#omni#input_patterns = {}
    let g:deoplete#omni#input_patterns.ruby =
          \ ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']
    let g:deoplete#omni#input_patterns.python = ''

    let g:deoplete#enable_refresh_always = 1
    let g:deoplete#enable_camel_case = 1

    " deoplete-clang "{{{
    " libclang shared library path
    let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'

    " clang builtin header path
    let g:deoplete#sources#clang#clang_header = '/usr/include/clang'

    " libclang default compile flags
    let g:deoplete#sources#clang#flags = ['-x', 'c++', '-std=c++11']
    "}}}
  endfunction
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:deoplete_on_source()'
endif "}}}

if dein#tap('neocomplete.vim') && has('lua') "{{{
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1

  function! s:neocomplete_on_source() abort
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#enable_camel_case = 1
    " Use fuzzy completion.
    let g:neocomplete#enable_fuzzy_completion = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    " Set auto completion length.
    let g:neocomplete#auto_completion_start_length = 2
    " Set manual completion length.
    let g:neocomplete#manual_completion_start_length = 0
    " Set minimum keyword length.
    let g:neocomplete#min_keyword_length = 3

    " Define dictionary.
    let g:neocomplete#sources#dictionary#directories = {
          \ 'default' : '',
          \ 'vimshell' : $CACHE.'/vimshell/command-history'
          \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns._ = '\h\k*(\?'

    " Plugin key-mappings.
    inoremap <expr> <C-g> neocomplete#undo_completion()
    inoremap <expr> <C-l> neocomplete#complete_common_string()

    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function() abort
      return neocomplete#smart_close_popup() . "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr> <C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr> <BS>  neocomplete#smart_close_popup()."\<C-h>"
    " <C-y>: paste.
    inoremap <expr> <C-y> pumvisible() ? neocomplete#close_popup() : "\<C-r>\""
    " <C-e>: close popup.
    inoremap <expr> <C-e> pumvisible() ? neocomplete#cancel_popup() : "\<End>"
    " Close popup by <Space>.
    " inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

    " AutoComplPop like behavior.
    let g:neocomplete#enable_auto_select = 1

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns = {}
    endif
    if !exists('g:neocomplete#sources#omni#functions')
      let g:neocomplete#sources#omni#functions = {}
    endif
    if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#enable_auto_close_preview = 1

    let g:neocomplete#sources#omni#input_patterns.c =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
    let g:neocomplete#sources#omni#input_patterns.cpp =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
    " let g:neocomplete#sources#omni#input_patterns.ruby =
    "       \ '[^. *\t]\.\w*\|\h\w*::\w*'
    let g:neocomplete#sources#omni#input_patterns.python =
          \ '[^. *\t]\.\w*\|\h\w*'
    let g:neocomplete#force_omni_input_patterns.objc =
          \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
    let g:neocomplete#force_omni_input_patterns.ruby =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    let g:neocomplete#sources#omni#functions.go =
          \ 'gocomplete#Complete'
  endfunction
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:neocomplete_on_source()'
endif "}}}

if dein#tap('neocomplcache.vim') && !has('lua') "{{{
  " Use neocomplcache.
  let g:neocomplcache_enable_at_startup = 1

  function! s:neocomplcache_on_source() abort
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

    let g:neocomplcache_enable_auto_close_preview = 1

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
          \ 'vimshell' : $CACHE .'/.vimshell/command-history'
          \ }

    " Define keyword.
    if !exists('g:neocomplcache_keyword_patterns')
      let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns['default'] = '[0-9a-zA-Z:#_]\+'
    let g:neocomplete#enable_multibyte_completion = 1

    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function() abort
      return neocomplcache#smart_close_popup() . "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr> <C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr> <BS>  neocomplcache#smart_close_popup()."\<C-h>"
    " <C-y>: paste.
    inoremap <expr> <C-y> pumvisible() ? neocomplcache#close_popup() : "\<C-r>\""
    " <C-e>: close popup.
    inoremap <expr> <C-e> pumvisible() ? neocomplcache#cancel_popup() : "\<End>"

    " AutoComplPop like behavior.
    let g:neocomplcache_enable_auto_select = 1

    " Enable heavy omni completion.
    if !exists('g:neocomplcache_omni_patterns')
      let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
    " let g:neocomplcache_force_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
    let g:neocomplcache_force_omni_patterns.python = '[^. \t]\.\w*'
    let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  endfunction
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:neocomplcache_on_source()'
endif "}}}

if dein#tap('neopairs.vim') "{{{
  let g:neopairs#enable = 0
endif "}}}

if dein#tap('neosnippet.vim') "{{{
  function! s:neosnippet_on_source() abort
    imap <C-k> <Plug>(neosnippet_expand_or_jump)
    smap <C-k> <Plug>(neosnippet_expand_or_jump)
    xmap <C-k> <Plug>(neosnippet_expand_target)
    imap <C-s> <Plug>(neosnippet_start_unite_snippet)
    xmap <C-l> <Plug>(neosnippet_start_unite_snippet_target)

    " Enable snipMate compatibility feature.
    let g:neosnippet#enable_snipmate_compatibility = 1
    let g:neosnippet#enable_complete_done = 1
    let g:neosnippet#expand_word_boundary = 1

    " let g:snippets_dir = '~/.vim/snippets/,~/.vim/bundle/snipmate/snippets/'
    let g:neosnippet#snippets_directory = '~/.vim/snippets'
  endfunction
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:neosnippet_on_source()'
endif "}}}

if dein#tap('unite.vim') "{{{
  " The prefix key.
  nnoremap [unite] <Nop>
  xnoremap [unite] <Nop>
  nmap ; [unite]
  xmap ; [unite]

  nnoremap <silent> [unite]b
        \ :<C-u>Unite -buffer-name=build`tabpagenr()` -no-quit build<CR>
  nnoremap <silent> [unite]c
        \ :<C-u>Unite gtags/context -buffer-name=search -auto-preview -no-quit<CR>
  nnoremap <silent> [unite]d
        \ :<C-u>UniteWithBufferDir -buffer-name=files file file/new<CR>
  nnoremap <silent> [unite]f
        \ :<C-u>Unite buffer file_mru bookmark<CR>
  nnoremap <silent> [unite]j
        \ :<C-u>Unite change jump<CR>
  nnoremap <silent> [unite]o
        \ :<C-u>Unite outline -start-insert -resume<CR>
  nnoremap <silent> [unite]r
        \ :<C-u>Unite -buffer-name=register -default-action=append register history/yank<CR>
  xnoremap <silent> [unite]r
        \ d:<C-u>Unite -buffer-name=register -default-action=append register history/yank<CR>
  nnoremap <silent> [unite]s
        \ :<C-u>Unite source<CR>
  nnoremap <silent> [unite]t
        \ :<C-u>UniteWithCursorWord -buffer-name=tag tag tag/include<CR>
  nnoremap <silent> [Window]s
        \ :<C-u>Unite -buffer-name=files -no-split -multi-line -unique -silent
        \ jump_point file_point buffer_tab:- file_mru
        \ `finddir('.git', ';') != '' ? 'file_rec/git' : ''`
        \ buffer_tab:- file file/new<CR>
  nnoremap <silent> [Window]t
        \ :<C-u>Unite -start-insert tig<CR>
  nnoremap <silent> [Window]w
        \ :<C-u>Unite -force-immediately window:all:no-current<CR>

  nnoremap <silent> [unite]g
        \ :<C-u>Unite grep:. -buffer-name=grep`tabpagenr()` -auto-preview<CR>
  nnoremap <silent> [unite]G
        \ :<C-u>Unite grep:.::`expand('<cword>')` -buffer-name=search -auto-preview<CR>
  xnoremap <silent> [unite]G
        \ :<C-u>call <SID>visual_grep()<CR>
  function! s:visual_grep() abort
    let tmp = @@
    silent normal gvy
    let selected = @@
    let @@ = tmp
    execute 'Unite grep:.::' . selected . ' -buffer-name=search -auto-preview'
  endfunction
  nnoremap <silent> [Space]b :<C-u>UniteBookmarkAdd<CR>

  " t: tags-and-searches "{{{
  " The prefix key.
  nnoremap [Tag] <Nop>
  nmap t [Tag]
  " Jump.
  nnoremap [Tag]t <C-]> zv zz
  " Jump next.
  nnoremap <silent> [Tag]n :<C-u>tnext<CR>
  " Jump previous.
  nnoremap <silent> [Tag]p :<C-u>pop<CR>
  " nnoremap <silent><expr> [Tag]t &filetype == 'help' ?  "g\<C-]>" :
  "       \ ":\<C-u>UniteWithCursorWord -buffer-name=tag -immediately tag tag/include\<CR>"
  " nnoremap <silent><expr> [Tag]p &filetype == 'help' ?
  "       \ ":\<C-u>pop\<CR>" : ":\<C-u>Unite jump\<CR>"
  "}}}

  " Execute help.
  nnoremap <silent> <C-h> :<C-u>Unite -buffer-name=help help<CR>
  " Execute help by cursor keyword.
  nnoremap <silent> g<C-h> :<C-u>UniteWithCursorWord help<CR>

  function! s:unite_on_source() abort
    " Start insert.
    call unite#custom#profile('action', 'context', {
          \ 'start_insert' : 1
          \ })

    " migemo.
    call unite#custom#source('line_migemo', 'matchers', 'matcher_migemo')

    " Keymapping in unite.vim.
    autocmd MyAutoCmd FileType unite call s:unite_my_settings()
    function! s:unite_my_settings() abort "{{{
      call unite#custom#default_action('directory', 'narrow')

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
      nnoremap <silent><buffer><expr> P
            \ unite#smart_map('P', unite#do_action('insert'))

      let unite = unite#get_current_unite()
      if unite.buffer_name =~# '^search'
        nnoremap <silent><buffer><expr> r unite#do_action('replace')
      else
        nnoremap <silent><buffer><expr> r unite#do_action('rename')
      endif

      nnoremap <silent><buffer><expr> cd unite#do_action('lcd')
      nnoremap <buffer><expr> S      unite#mappings#set_current_sorters(
            \ empty(unite#mappings#get_current_sorters()) ? ['sorter_reverse'] : [])
      nmap <buffer> x <Plug>(unite_quick_match_jump)
    endfunction"}}}

    let g:unite_enable_auto_select = 0

    if executable('hw')
      " Use hw(highway)
      " https://github.com/tkengo/highway
      let g:unite_source_grep_command = 'hw'
      let g:unite_source_grep_default_opts = '--no-group --no-color'
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('ag')
      " Use ag(the silver searcher)
      " https://github.com/ggreer/the_silver_searcher
      let g:unite_source_grep_command = 'ag'
      let g:unite_source_grep_default_opts =
        \ '-i --vimgrep --hidden --ignore ' .
        \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('pt')
      " Use pt(the platinum searcher)
      " https://github.com/monochromegane/the_platinum_searcher
      let g:unite_source_grep_command = 'pt'
      let g:unite_source_grep_default_opts = '--nogroup --nocolor'
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('ack-grep')
      " For ack
      " http://beyondgrep.com/
      let g:unite_source_grep_command = 'ack-grep'
      let g:unite_source_grep_default_opts = '-i --no-heading --no-color -k -H'
      let g:unite_source_grep_recursive_opt = ''
    endif

    " For unite-alias.
    let g:unite_source_alias_aliases = {}
    let g:unite_source_alias_aliases.line_migemo = 'line'

    " For unite-menu.
    let g:unite_source_menu_menus = {}

    let g:unite_source_menu_menus.unite = {
          \ 'description' : 'Start unite sources',
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
    nnoremap <silent> [unite]u :<C-u>Unite menu:unite -resume<CR>

    let g:unite_build_error_icon   = expand('~/.vim') . '/signs/err.'
          \ . (s:is_windows ? 'bmp' : 'png')
    let g:unite_build_warning_icon = expand('~/.vim') . '/signs/warn.'
          \ . (s:is_windows ? 'bmp' : 'png')
  endfunction
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:unite_on_source()'
endif "}}}

if dein#tap('vimfiler.vim') "{{{
  nnoremap <silent> <C-g> :<C-u>VimFiler -buffer-name=explorer -simple -toggle<CR>

  function! s:vimfiler_on_source() abort
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
      let g:vimfiler_readonly_file_icon = '✗'
      let g:vimfiler_marked_file_icon = '✓'
    endif

    autocmd MyAutoCmd FileType vimfiler call s:vimfiler_my_settings()
    function! s:vimfiler_my_settings() abort "{{{
      " Overwrite settings.
      nnoremap <silent><buffer> J
            \ :<C-u>Unite -buffer-name=files -default-action=lcd directory_mru<CR>

      nnoremap <silent><buffer><expr> gy vimfiler#do_action('tabopen')
      nmap <buffer> p <Plug>(vimfiler_quick_look)
      nmap <buffer> <Tab> <Plug>(vimfiler_switch_to_other_window)

      " Migemo search.
      if !empty(unite#get_filters('matcher_migemo'))
        nnoremap <silent><buffer><expr> / line('$') > 10000 ? 'g/' :
              \ ":\<C-u>Unite -buffer-name=search -start-insert line_migemo\<CR>"
      endif
    endfunction"}}}
  endfunction
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:vimfiler_on_source()'
endif "}}}

if dein#tap('vimshell.vim') "{{{
  nmap <silent> <C-@> <Plug>(vimshell_switch)

  function! s:vimshell_on_source() abort
    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    "let g:vimshell_right_prompt = 'fugitive#statusline()'
    let g:vimshell_right_prompt =
           \ 'gita#statusline#format("%{|/}ln%lb%{ <> |}rn%{/|}rb")'
    let g:vimshell_prompt = '% '
    let g:vimshell_split_command = ''
    let g:vimshell_enable_transient_user_prompt = 1
    let g:vimshell_force_overwrite_statusline = 1

    autocmd MyAutoCmd FileType vimshell call s:vimshell_settings()
    function! s:vimshell_settings() abort "{{{
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
      imap <buffer><BS>  <Plug>(vimshell_another_delete_backward_char)
      imap <buffer><C-h> <Plug>(vimshell_another_delete_backward_char)
      imap <buffer><C-k> <Plug>(vimshell_zsh_complete)
      imap <buffer><C-g> <Plug>(vimshell_history_neocomplete)

      xmap <buffer> y <Plug>(operator-concealedyank)

      nnoremap <silent><buffer> <C-j>
            \ :<C-u>Unite -buffer-name=files
            \ -default-action=lcd directory_mru<CR>

      call vimshell#set_alias('ll', 'ls -l')
      call vimshell#set_alias('la', 'ls -alF')
      call vimshell#set_alias('l', 'ls -CF')
      call vimshell#set_alias('l.', 'ls -d .*')
      call vimshell#set_alias('cp', 'cp -i')
      call vimshell#set_alias('rm', 'rm -i')
      call vimshell#set_alias('mv', 'mv -i')
    endfunction"}}}
  endfunction
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:vimshell_on_source()'
endif "}}}

if dein#tap('vinarise.vim') "{{{
  let g:vinarise_enable_auto_detect = 1
endif "}}}

if dein#tap('vim-choosewin') "{{{
  nmap g<C-w>  <Plug>(choosewin)
  let g:choosewin_overlay_enable = 1
  let g:choosewin_overlay_clear_multibyte = 1
  let g:choosewin_blink_on_land = 0
endif "}}}

if dein#tap('vim-expand-region') "{{{
  xmap v <Plug>(expand_region_expand)
  xmap <C-v> <Plug>(expand_region_shrink)
endif "}}}

if dein#tap('vim-qfreplace') "{{{
  autocmd MyAutoCmd FileType qf nnoremap <buffer> r :<C-u>Qfreplace<CR>
endif "}}}

if dein#tap('vim-quickrun') "{{{
  let g:quickrun_config = {}
  let g:quickrun_config['markdown'] = {
        \ 'outputter': 'browser'
        \ }
  nmap <silent> <Leader>r <Plug>(quickrun)
endif "}}}

if dein#tap('vim-ref') "{{{
  function! s:ref_on_source(bundle) abort
    let g:ref_cache_dir = expand('$CACHE/ref')
    let g:ref_use_vimproc = 1
    if s:is_windows
      let g:ref_refe_encoding = 'cp932'
    endif

    autocmd MyAutoCmd FileType ref call s:ref_my_settings()
    function! s:ref_my_settings() abort "{{{
      " Overwrite settings.
      nmap <buffer> [Tag]t <Plug>(ref-keyword)
      nmap <buffer> [Tag]p <Plug>(ref-back)
      nnoremap <buffer> <TAB> <C-w>w
    endfunction"}}}
  endfunction
  execute 'autocmd MyAutoCmd User' 'dein#source#'.g:dein#name
        \ 'call s:ref_on_source()'
endif "}}}

" if dein#tap('vim-fugitive') "{{{
"   nnoremap <silent> [Space]gd :<C-u>call <SID>fugitive_tab('Gdiff')<CR>
"   nnoremap <silent> [Space]gs :<C-u>Gstatus<CR>
"   nnoremap <silent> [Space]gl :<C-u>call <SID>fugitive_tab('Glog')<CR>
"   nnoremap <silent> [Space]ga :<C-u>Gwrite<CR>
"   nnoremap <silent> [Space]gA :<C-u>Gwrite %<CR>
"   nnoremap <silent> [Space]gc :<C-u>Gcommit<CR>
"   nnoremap <silent> [Space]gC :<C-u>Gcommit --amend<CR>
"   nnoremap <silent> [Space]gb :<C-u>call <SID>fugitive_tab('Gblame')<CR>
"   function! s:fugitive_tab(cmd) abort
"     if s:is_windows
"       setlocal shellpipe=2>\&1\|iconv\ -f\ UTF-8\ -t\ CP932>%s
"     endif
"     execute 'tabedit ' . expand('%')
"     execute a:cmd
"     if s:is_windows
"       setlocal shellpipe&
"     endif
"   endfunction
" endif "}}}

if dein#tap('caw.vim') "{{{
  autocmd MyAutoCmd FileType * call s:init_caw()
  function! s:init_caw() abort
    if !&l:modifiable
      silent! nunmap <buffer> gc
      silent! xunmap <buffer> gc
      silent! nunmap <buffer> gcc
      silent! xunmap <buffer> gcc
    else
      nmap <buffer> gc <Plug>(caw:prefix)
      xmap <buffer> gc <Plug>(caw:prefix)
      nmap <buffer> gcc <Plug>(caw:i:toggle)
      xmap <buffer> gcc <Plug>(caw:i:toggle)
    endif
  endfunction
endif "}}}

if dein#tap('open-browser.vim') "{{{
  let g:netrw_nogx = 1 " disable netrw's gx mapping.
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)
endif "}}}

if dein#tap('w3m.vim') "{{{
  nnoremap [Alt]w :<C-u>W3mTab<Space>
  if s:is_windows || s:is_msys
    let g:w3m#external_browser = 'C:/Program\ Files\ (x86)/Google/Chrome/Application/chrome.exe'
  elseif s:is_mac
    let g:w3m#external_browser = 'open -a "Google Chrome"'
  elseif s:is_freebsd
    let g:w3m#external_browser = 'chrome'
  else
    let g:w3m#external_browser = 'chromium'
  endif
  let g:w3m#search_engine = 'https://www.google.co.jp/search?ie=' . &encoding . '&q=%s'
  autocmd MyAutoCmd FileType w3m call s:w3m_settings()
  function! s:w3m_settings() abort
    nnoremap <buffer> H :<C-u>call w3m#Back()<CR>
    nnoremap <buffer> L :<C-u>call w3m#Forward()<CR>
    nnoremap <buffer> E :<C-u>W3mShowExtenalBrowser<CR>
    nnoremap <buffer> Q :<C-u>W3mClose<CR>
  endfunction
endif "}}}
"}}}

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

