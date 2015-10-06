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

let s:neobundle_dir = expand('~/.vim/bundle')

if has('vim_starting') "{{{
  if s:is_windows
    execute 'set runtimepath+=' . expand('~/.vim')
  endif

  " Load neobundle.
  if finddir('neobundle.vim', '.;') != ''
    execute 'set runtimepath^=' .
          \ fnamemodify(finddir('neobundle.vim', '.;'), ':p')
  elseif &runtimepath !~ '/neobundle.vim'
    if !isdirectory(s:neobundle_dir.'/neobundle.vim')
      execute printf('!git clone %s://github.com/Shougo/neobundle.vim.git',
            \ (exists('$http_proxy') ? 'https' : 'git'))
            \ s:neobundle_dir.'/neobundle.vim'
    endif

    execute 'set runtimepath^=' . s:neobundle_dir.'/neobundle.vim'
  endif
endif
"}}}

call neobundle#begin(s:neobundle_dir)

" neobundle.vim "{{{
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'altercation/vim-colors-solarized'
NeoBundleLazy 'basyura/TweetVim', {
      \ 'depends' : ['basyura/twibill.vim', 'tyru/open-browser.vim'],
      \ 'commands' : 'TweetVimHomeTimeline',
      \ }
NeoBundleLazy 'bkad/CamelCaseMotion', {
      \ 'mappings' : '<Plug>',
      \ }
NeoBundleLazy 'chikatoike/concealedyank.vim', {
      \ 'mappings' : [['x', '<Plug>(operator-concealedyank)']],
      \ }
NeoBundleLazy 'davidhalter/jedi-vim', {
      \ 'filetypes' : 'python',
      \ }
NeoBundleLazy 'elzr/vim-json', {
      \ 'filetypes' : 'json',
      \ }
NeoBundleLazy 'gregsexton/gitv', {
      \ 'commands' : 'Gitv',
      \ }
" NeoBundleLazy 'h1mesuke/vim-alignta', {
"       \ 'insert' : 1,
"       \ }
NeoBundleLazy 'hail2u/vim-css3-syntax'
NeoBundleLazy 'hewes/unite-gtags', {
      \ 'unite_sources' : ['gtags/context'],
      \ }
NeoBundleLazy 'hynek/vim-python-pep8-indent', {
      \ 'filetypes' : 'python',
      \ }
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
      \ 'filetypes' : 'javascript',
      \ }
NeoBundleLazy 'jelera/vim-javascript-syntax', {
      \ 'filetypes' : 'javascript',
      \ }
NeoBundleLazy 'junegunn/vim-easy-align', {
      \ 'mappings' : '<Plug>(EasyAlign)',
      \ }
NeoBundleLazy 'kana/vim-niceblock', {
      \ 'mappings' : '<Plug>',
      \ }
NeoBundleLazy 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-operator-replace', {
      \ 'depends' : 'vim-operator-user',
      \ 'mappings' : [['nx', '<Plug>']],
      \ }
NeoBundleLazy 'kannokanno/previm', {
      \ 'filetypes' : ['markdown', 'rst', 'mkd'],
      \ 'depends' : 'tyru/open-browser.vim',
      \ }
NeoBundleLazy 'kana/vim-smartchr', {
      \ 'insert' : 1,
      \ }
NeoBundleLazy 'Kocha/vim-unite-tig'
" NeoBundleLazy 'lambdalisue/vim-gita', {
"       \ 'commands': 'Gita',
"       \ }
NeoBundleLazy 'mrtazz/DoxygenToolkit.vim', {
      \ 'filetypes' : ['c', 'cpp'],
      \ }
NeoBundleLazy 'osyo-manga/unite-quickfix'
NeoBundleLazy 'osyo-manga/vim-jplus', {
      \ 'mappings' : '<Plug>',
      \ }
NeoBundleLazy 'osyo-manga/vim-monster', {
      \ 'filetypes' : 'ruby',
      \ }
NeoBundleLazy 'rcmdnk/vim-markdown', {
      \ 'filetypes' : ['markdown', 'mkd'],
      \ }
if has('python')
NeoBundleLazy 'Rip-Rip/clang_complete', {
      \ 'filetypes' : ['c', 'cpp'],
      \ }
else
NeoBundleFetch 'Rip-Rip/clang_complete'
endif
NeoBundleLazy 'rhysd/accelerated-jk', {
      \ 'mappings' : '<Plug>',
      \ }
NeoBundleLazy 'rhysd/vim-operator-surround', {
      \ 'depends' : 'vim-operator-user',
      \ 'mappings' : '<Plug>',
      \ }
NeoBundleLazy 'LeafCage/foldCC', {
      \ 'filetypes' : 'vim',
      \ }
NeoBundleLazy 'Rykka/riv.vim', {
      \ 'filetypes' : 'rst',
      \ }
NeoBundleLazy 'saihoooooooo/glowshi-ft.vim', {
      \ 'mappings' : '<Plug>',
      \ }
if has('lua')
NeoBundleFetch 'Shougo/neocomplcache.vim'
NeoBundleLazy 'Shougo/neocomplete.vim', {
      \ 'depends' : 'Shougo/context_filetype.vim',
      \ 'insert' : 1,
      \ }
else
NeoBundleLazy 'Shougo/neocomplcache.vim', {
      \ 'insert' : 1,
      \ }
NeoBundleFetch 'Shougo/neocomplete.vim'
endif
NeoBundleLazy 'Shougo/neoinclude.vim', {
      \ 'insert' : 1,
      \ }
NeoBundle 'Shougo/neomru.vim'
NeoBundleLazy 'Shougo/neosnippet.vim', {
      \ 'depends' : ['Shougo/neosnippet-snippets', 'Shougo/context_filetype.vim'],
      \ 'insert' : 1,
      \ 'filetypes' : 'snippet',
      \ 'unite_sources' : [
      \    'neosnippet', 'neosnippet/user', 'neosnippet/runtime'],
      \ }
NeoBundleLazy 'Shougo/neossh.vim', {
      \ 'filetypes' : ['vimfiler', 'vimshell'],
      \ 'sources' : 'ssh',
      \ }
NeoBundleLazy 'Shougo/unite.vim', {
      \ 'depends' : 'Shougo/neomru.vim',
      \ 'commands' : [
      \   {'name' : 'Unite',
      \    'complete' : 'customlist,unite#complete_source'},
      \   'UniteWithCursorWord'],
      \ }
NeoBundleLazy 'Shougo/unite-build'
NeoBundleLazy 'Shougo/unite-help'
NeoBundleLazy 'Shougo/unite-outline'
NeoBundleLazy 'Shougo/unite-sudo'
NeoBundleLazy 'Shougo/vimfiler.vim', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'commands' :
      \   {'name' : ['VimFiler', 'VimFilerExplorer', 'Edit', 'Write'],
      \    'complete' : 'customlist,vimfiler#complete' },
      \ 'mappings' : '<Plug>',
      \ 'explorer' : 1,
      \ }
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \   'windows' : 'tools\\update-dll-mingw',
      \   'cygwin' : 'make',
      \   'mac' : 'make',
      \   'linux' : 'make',
      \   'unix' : 'gmake',
      \   },
      \ }
NeoBundleLazy 'Shougo/vimshell.vim', {
      \ 'commands' :
      \   {'name' : 'VimShell',
      \    'complete' : 'customlist,vimshell#complete'},
      \ 'mappings' : '<Plug>',
      \ }
NeoBundleLazy 'Shougo/vinarise.vim', {
      \ 'commands' : [{'name' : 'Vinarise', 'complete' : 'file'}],
      \ }
NeoBundleLazy 'terryma/vim-expand-region', {
      \ 'mappings' : [['x', '<Plug>']],
      \ }
NeoBundleLazy 'thinca/vim-qfreplace', {
      \ 'filetypes' : ['unite', 'quickfix'],
      \ }
NeoBundleLazy 'thinca/vim-quickrun', {
      \ 'mappings' : '<Plug>',
      \ }
NeoBundleLazy 'thinca/vim-ref', {
      \ 'unite_sources' : 'ref',
      \ }
NeoBundleLazy 'todesking/ruby_hl_lvar.vim', {
      \ 'filetypes' : 'ruby',
      \ }
NeoBundle 'tpope/vim-fugitive', {
      \ 'commands' : ['Gdiff', 'Gstatus', 'Glog',
      \               'Gwrite', 'Gcommit', 'Gblame'],
      \ }
NeoBundleLazy 'tsukkee/unite-tag'
NeoBundleLazy 'tyru/caw.vim', {
      \ 'mappings' : '<Plug>',
      \ }
NeoBundleLazy 'tyru/open-browser.vim', {
      \ 'mappings' : '<Plug>',
      \ 'commands' : ['OpenBrowser', 'OpenBrowserSearch'],
      \ }
NeoBundleLazy 'ujihisa/vimshell-ssh', {
      \ 'filetypes' : 'vimshell',
      \ }
NeoBundleLazy 'vim-jp/autofmt', {
      \ 'mappings' : [['x', 'gq']],
      \ }
NeoBundleLazy 'vim-jp/cpp-vim', {
      \ 'filetypes' : 'cpp',
      \ }
NeoBundleLazy 'vim-ruby/vim-ruby', {
      \ 'mappings' : '<Plug>',
      \ 'filetypes' : 'ruby',
      \ }
NeoBundleLazy 'vim-scripts/taglist.vim', {
      \ 'commands' : 'TlistOpen',
      \ }
NeoBundle 'Yggdroot/indentLine'
NeoBundleLazy 'yomi322/vim-gitcomplete', {
      \ 'filetype' : 'vimshell',
      \ }
NeoBundleLazy 'yuratomo/w3m.vim', {
      \ 'commands' : 'W3mTab',
      \ }

call neobundle#end()

" Installation check.
NeoBundleCheck
"}}}

"-----------------------------------------------------------------------------
" Encoding: "{{{
"
" The automatic recognition of the character code.

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
if !s:is_windows
  set encoding=utf-8
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
function! s:ReCheck_FENC() "{{{
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
if has('unnamedplus')
  set clipboard& clipboard^=unnamedplus
else
  set clipboard& clipboard^=unnamed
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
" autocmd MyAutoCmd BufWritePost .vimrc,vimrc source $MYVIMRC |
"       \ if has('gui_running') | source $MYGVIMRC | echo "source $MYVIMRC"
" autocmd MyAutoCmd BufWritePost .gvimrc,gvimrc
"       \ if has('gui_running') | source $MYGVIMRC | echo "source $MYGVIMRC"

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
set statusline=%<%m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %1.40f%=%{fugitive#statusline()}\ \ %l/%L,%c%V%5P
"set statusline=%<%m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}\ %1.40f%=%{gita#statusline#preset('branch')}\ \ %l/%L,%c%V%5P

" Turn down a long line appointed in 'breakat'
" set linebreak
" set showbreak=\
" set breakat=\ \	;:,!?
" Wrap conditions.
set whichwrap+=h,l,<,>,[,],b,s,~
" Wrap long lines.
set wrap
if exists('+breakindent')
  set breakindent
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

" Don't redraw while macro executing.
set lazyredraw
set ttyfast

" When a line is long, do not omit it in @.
set display=lastline

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
  autocmd FileType gitcommit,qfreplace setlocal nofoldenable

  " Enable omni completion.
  autocmd FileType c setlocal omnifunc=ccomplete#Complete
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  " autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END
"}}}

" XML
let g:xml_syntax_folding = 1

" JavaScript
let g:SimpleJsIndenter_BriefMode = 1
let g:SimpleJsIndenter_CaseIndentLevel = -1

"-----------------------------------------------------------------------------
" Plugin: "{{{
"
if neobundle#tap('vim-operator-surround') "{{{
  nmap <silent>sa <Plug>(operator-surround-append)a
  nmap <silent>sd <Plug>(operator-surround-delete)a
  nmap <silent>sr <Plug>(operator-surround-replace)a

  call neobundle#untap()
endif "}}}

if neobundle#tap('TweetVim') "{{{
  " Start TweetVim.
  nnoremap <silent> [unite]e :<C-u>Unite tweetvim<CR>
  autocmd MyAutoCmd FileType tweetvim call s:tweetvim_my_settings()
  function! s:tweetvim_my_settings() "{{{
    " Open say buffer.
    nnoremap <silent><buffer> s :<C-u>TweetVimSay<CR>
    nnoremap <silent><buffer> q :<C-u>close<CR>
    nmap <silent><buffer> j <Plug>(accelerated_jk_gj)
  endfunction"}}}

  let g:tweetvim_display_separator = 0

  call neobundle#untap()
endif "}}}

if neobundle#tap('CamelCaseMotion') "{{{
  nmap <silent> W <Plug>CamelCaseMotion_w
  xmap <silent> W <Plug>CamelCaseMotion_w
  omap <silent> W <Plug>CamelCaseMotion_w
  nmap <silent> B <Plug>CamelCaseMotion_b
  xmap <silent> B <Plug>CamelCaseMotion_b
  omap <silent> B <Plug>CamelCaseMotion_b

  call neobundle#untap()
endif "}}}

if neobundle#tap('concealedyank.vim') "{{{
  xmap Y <Plug>(operator-concealedyank)

  call neobundle#untap()
endif "}}}

if neobundle#tap('jedi-vim') "{{{
  autocmd MyAutoCmd FileType python
        \ if has('python') || has('python3') |
        \   setlocal omnifunc=jedi#completions |
        \ else |
        \   setlocal omnifunc= |
        \ endif
  let g:jedi#completions_enabled = 0
  let g:jedi#auto_vim_configuration = 0

  call neobundle#untap()
endif "}}}

if neobundle#tap('gitv') "{{{
  nnoremap <silent> [Space]gv :<C-u>Gitv<CR>
  nnoremap <silent> [Space]gf :<C-u>Gitv!<CR>

  call neobundle#untap()
endif "}}}

" if neobundle#tap('vim-alignta') "{{{
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
"
"   call neobundle#untap()
" endif "}}}

if neobundle#tap('vim-niceblock') "{{{
  xmap I <Plug>(niceblock-I)
  xmap A <Plug>(niceblock-A)

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-easy-align') "{{{
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

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-operator-replace') "{{{
  xmap p <Plug>(operator-replace)

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-smartchr') "{{{
  function! neobundle#hooks.on_source(bundle)
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

  call neobundle#untap()
endif "}}}

if neobundle#tap('DoxygenToolkit.vim') "{{{
  nnoremap <silent> [Space]x :<C-u>Dox<CR>
  let g:load_doxygen_syntax = 1

  call neobundle#untap()
endif "}}}

" if neobundle#tap('vim-gita') "{{{
"   nnoremap <silent> [Space]gs  :<C-u>Gita status<CR>
"   nnoremap <silent> [Space]gc  :<C-u>Gita commit<CR>
"   nnoremap <silent> [Space]gd  :<C-u>Gita diff<CR>
"
"   call neobundle#untap()
" endif "}}}

if neobundle#tap('vim-jplus') "{{{
  nmap J <Plug>(jplus)
  vmap J <Plug>(jplus)

  call neobundle#untap()
endif "}}}

if neobundle#tap('accelerated-jk') "{{{
  nmap <silent>j <Plug>(accelerated_jk_gj)
  nmap gj j
  nmap <silent>k <Plug>(accelerated_jk_gk)
  nmap gk k

  call neobundle#untap()
endif "}}}

if neobundle#tap('glowshi-ft.vim') "{{{
  let g:glowshi_ft_no_default_key_mappings = 1
  map f <Plug>(glowshi-ft-f)
  map F <Plug>(glowshi-ft-F)

  let g:glowshi_ft_timeoutlen = 1000

  call neobundle#untap()
endif "}}}

if neobundle#tap('neocomplete.vim') && has('lua') "{{{
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1

  function! neobundle#hooks.on_source(bundle)
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
    let g:neocomplete#keyword_patterns._ = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr> <C-g> neocomplete#undo_completion()
    inoremap <expr> <C-l> neocomplete#complete_common_string()

    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
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
    if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
    endif
    let g:neocomplete#sources#omni#input_patterns.c =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
    let g:neocomplete#sources#omni#input_patterns.cpp =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
    " let g:neocomplete#sources#omni#input_patterns.ruby =
    "       \ '[^. *\t]\.\w*\|\h\w*::\w*'
    let g:neocomplete#enable_auto_close_preview = 1
    let g:neocomplete#force_omni_input_patterns.c =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\w*'
    let g:neocomplete#force_omni_input_patterns.cpp =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
    let g:neocomplete#force_omni_input_patterns.objc =
          \ '\[\h\w*\s\h\?\|\h\w*\%(\.\|->\)'
    let g:neocomplete#force_omni_input_patterns.ruby =
          \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
    let g:neocomplete#force_omni_input_patterns.python =
          \ '\h\w*\|[^. \t]\.\w*'
    " For clang_complete.
    let g:clang_complete_auto = 0
    let g:clang_auto_select = 0
    let g:clang_default_keymappings = 0
    let g:clang_use_library = 1
    if s:is_windows
      let g:clang_library_path = 'C:/msys64/usr/local/lib'
    endif
  endfunction

  call neobundle#untap()
endif "}}}

if neobundle#tap('neocomplcache.vim') && !has('lua') "{{{
  " Use neocomplcache.
  let g:neocomplcache_enable_at_startup = 1

  function! neobundle#hooks.on_source(bundle)
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

    " For clang_complete.
    let g:neocomplcache_force_overwrite_completefunc = 1
    let g:clang_auto_select = 0
    let g:clang_complete_auto = 0
    let g:clang_use_library = 1
    if s:is_windows
      let g:clang_library_path = 'C:/msys64/usr/local/lib'
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
    let g:neocomplcache_keyword_patterns['default'] = '[0-9a-zA-Z:#_]\+'
    let g:neocomplete#enable_multibyte_completion = 1

    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
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

  call neobundle#untap()
endif "}}}

if neobundle#tap('neosnippet.vim') "{{{
  function! neobundle#hooks.on_source(bundle)
    imap <C-k> <Plug>(neosnippet_expand_or_jump)
    smap <C-k> <Plug>(neosnippet_expand_or_jump)
    xmap <C-k> <Plug>(neosnippet_expand_target)
    imap <C-s> <Plug>(neosnippet_start_unite_snippet)
    xmap <C-l> <Plug>(neosnippet_start_unite_snippet_target)

    " Enable snipMate compatibility feature.
    " let g:neosnippet#enable_snipmate_compatibility = 1

    " let g:snippets_dir = '~/.vim/snippets/,~/.vim/bundle/snipmate/snippets/'
    let g:neosnippet#snippets_directory = '~/.vim/snippets'
  endfunction

  call neobundle#untap()
endif "}}}

if neobundle#tap('unite.vim') "{{{
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
        \ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec/async'`
        \ buffer_tab:- file file/new<CR>
  nnoremap <silent> [Window]t
        \ :<C-u>Unite -start-insert tig<CR>
  nnoremap <silent> [Window]w
        \ :<C-u>Unite window:all:no-current<CR>

  nnoremap <silent><expr> [unite]g
        \ :<C-u>Unite grep:. -buffer-name=grep`tabpagenr()` -auto-preview -no-quit -no-empty -resume<CR>
  nnoremap <silent> [unite]G
        \ :<C-u>call <SID>cursor_grep()<CR>
  xnoremap <silent> [unite]G
        \ :<C-u>call <SID>visual_grep()<CR>
  function! s:cursor_grep()
    let w = expand('<cword>')
    " call s:my_idenew()
    execute 'Unite grep:.::' . w . ' -buffer-name=search -auto-preview'
  endfunction
  function! s:visual_grep()
    let tmp = @@
    silent normal gvy
    let selected = @@
    let @@ = tmp
    " call s:my_idenew()
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
  nnoremap <silent> g<C-h>  :<C-u>UniteWithCursorWord help<CR>

  let g:unite_source_history_yank_enable = 1

  function! neobundle#hooks.on_source(bundle)
    " Start insert.
    call unite#custom#profile('action', 'context', {
          \ 'start_insert' : 1
          \ })

    " migemo.
    call unite#custom#source('line_migemo', 'matchers', 'matcher_migemo')

    " Keymapping in unite.vim.
    autocmd MyAutoCmd FileType unite call s:unite_my_settings()
    function! s:unite_my_settings() "{{{
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

    if executable('ag')
      " For ag.
      let g:unite_source_grep_command = 'ag'
      let g:unite_source_grep_default_opts =
        \ '-i --vimgrep --hidden --ignore ' .
        \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('pt')
      " For pt.
      let g:unite_source_grep_command = 'pt'
      let g:unite_source_grep_default_opts = '--nogroup --nocolor'
      let g:unite_source_grep_recursive_opt = ''
    elseif executable('ack-grep')
      " For ack.
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

  call neobundle#untap()
endif "}}}

if neobundle#tap('vimfiler.vim') "{{{
  nnoremap <silent> <C-g> :<C-u>VimFiler -buffer-name=explorer -simple -toggle<CR>

  function! neobundle#hooks.on_source(bundle)
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
    function! s:vimfiler_my_settings() "{{{
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

  call neobundle#untap()
endif "}}}

if neobundle#tap('vimshell.vim') "{{{
  nmap <silent> <C-@> <Plug>(vimshell_switch)

  function! neobundle#hooks.on_source(bundle)
    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    let g:vimshell_right_prompt = 'fugitive#statusline()'
    " let g:vimshell_right_prompt =
    "       \ 'gita#statusline#format("%{|/}ln%lb%{ <> |}rn%{/|}rb")'
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
      imap <buffer><BS>  <Plug>(vimshell_another_delete_backward_char)
      imap <buffer><C-h> <Plug>(vimshell_another_delete_backward_char)
      imap <buffer><C-k> <Plug>(vimshell_zsh_complete)
      imap <buffer><C-g> <Plug>(vimshell_history_neocomplete)

      xmap <buffer> y <Plug>(operator-concealedyank)

      nnoremap <silent><buffer> J
            \ :<C-u>Unite -buffer-name=files -default-action=lcd directory_mru<CR>
      call vimshell#set_alias('ll', 'ls -l')
      call vimshell#set_alias('la', 'ls -alF')
      call vimshell#set_alias('l', 'ls -CF')
      call vimshell#set_alias('l.', 'ls -d .*')
      call vimshell#set_alias('cp', 'cp -i')
      call vimshell#set_alias('rm', 'rm -i')
      call vimshell#set_alias('mv', 'mv -i')
    endfunction"}}}
  endfunction

  call neobundle#untap()
endif "}}}

if neobundle#tap('vinarise.vim') "{{{
  let g:vinarise_enable_auto_detect = 1

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-expand-region') "{{{
  xmap v <Plug>(expand_region_expand)
  xmap <C-v> <Plug>(expand_region_shrink)

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-qfreplace') "{{{
  autocmd MyAutoCmd FileType qf nnoremap <buffer> r :<C-u>Qfreplace<CR>

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-quickrun') "{{{
  let g:quickrun_config = {}
  let g:quickrun_config['markdown'] = {
        \ 'outputter': 'browser'
        \ }
  nmap <silent> <Leader>r <Plug>(quickrun)

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-ref') "{{{
  function! neobundle#hooks.on_source(bundle)
    autocmd MyAutoCmd FileType ref call s:ref_my_settings()
    function! s:ref_my_settings() "{{{
      " Overwrite settings.
      nmap <buffer> [Tag]t <Plug>(ref-keyword)
      nmap <buffer> [Tag]p <Plug>(ref-back)
    endfunction"}}}
  endfunction

  call neobundle#untap()
endif "}}}

if neobundle#tap('vim-fugitive') "{{{
  nnoremap <silent> [Space]gd :<C-u>call <SID>fugitive_tab('Gdiff')<CR>
  nnoremap <silent> [Space]gs :<C-u>Gstatus<CR>
  nnoremap <silent> [Space]gl :<C-u>call <SID>fugitive_tab('Glog')<CR>
  nnoremap <silent> [Space]ga :<C-u>Gwrite<CR>
  nnoremap <silent> [Space]gA :<C-u>Gwrite %<CR>
  nnoremap <silent> [Space]gc :<C-u>Gcommit<CR>
  nnoremap <silent> [Space]gC :<C-u>Gcommit --amend<CR>
  nnoremap <silent> [Space]gb :<C-u>call <SID>fugitive_tab('Gblame')<CR>
  function! s:fugitive_tab(cmd)
    if s:is_windows
      setlocal shellpipe=2>\&1\|iconv\ -f\ UTF-8\ -t\ CP932>%s
    endif
    execute 'tabedit ' . expand('%')
    execute a:cmd
    if s:is_windows
      setlocal shellpipe&
    endif
  endfunction

  call neobundle#untap()
endif "}}}

if neobundle#tap('caw.vim') "{{{
  autocmd MyAutoCmd FileType * call s:init_caw()
  function! s:init_caw()
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

  call neobundle#untap()
endif "}}}

if neobundle#tap('open-browser.vim') "{{{
  let g:netrw_nogx = 1 " disable netrw's gx mapping.
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

  call neobundle#untap()
endif "}}}

if neobundle#tap('taglist.vim') "{{{
  if s:is_mac || s:is_windows
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

  call neobundle#untap()
endif "}}}

if neobundle#tap('indentLine') "{{{
  let g:indentLine_faster = 1
  nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>

  call neobundle#untap()
endif "}}}

if neobundle#tap('w3m.vim') "{{{
  nnoremap [Alt]w :<C-u>W3mTab<Space>
  if s:is_mac
    let g:w3m#external_browser = 'open -a "Google Chrome"'
  elseif s:is_windows
    let g:w3m#external_browser = 'C:/Program\ Files\ (x86)/Google/Chrome/Application/chrome.exe'
  elseif s:is_freebsd
    let g:w3m#external_browser = 'chrome'
  else
    let g:w3m#external_browser = 'chromium'
  endif
  let g:w3m#search_engine = 'http://www.google.co.jp/search?ie=' . &encoding . '&q=%s'
  autocmd MyAutoCmd FileType w3m call s:w3m_settings()
  function! s:w3m_settings()
    nnoremap <buffer> H :<C-u>call w3m#Back()<CR>
    nnoremap <buffer> L :<C-u>call w3m#Forward()<CR>
    nnoremap <buffer> E :<C-u>W3mShowExtenalBrowser<CR>
    nnoremap <buffer> Q :<C-u>W3mClose<CR>
  endfunction

  call neobundle#untap()
endif "}}}
"}}}

"-----------------------------------------------------------------------------
" Key-mappings: "{{{
"
" Indent "{{{
nnoremap > >>
nnoremap < <<
xnoremap > >gv
xnoremap < <gv
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

nnoremap [Window] <Nop>
nmap s [Window]
nnoremap <silent> q :<C-u>call <SID>smart_close()<CR>
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
    VimFiler -buffer-name=explorer -toggle
  else
    execute 'tabedit ' . a:file
    vsplit
    wincmd l
    VimFiler -buffer-name=explorer -toggle
  endif
endfunction

function! s:my_idenew()
  tabnew
  TlistOpen
  VimFilerExplorer -winwidth=46
  wincmd l
endfunction
"}}}

" e: Change basic commands "{{{
" The prefix key.
nnoremap [Alt] <Nop>
xnoremap [Alt] <Nop>
onoremap [Alt] <Nop>
nmap e [Alt]
xmap e [Alt]
omap e [Alt]

nnoremap [Alt]e e
xnoremap [Alt]e e
"}}}

" Disable Ex-mode.
nnoremap Q q

" q: Quickfix "{{{
" The prefix key.
nnoremap [Quickfix] <Nop>

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
noremap [Space]u :<C-u>Unite outline:foldings<CR>"{{{"}}}
noremap [Space]z za
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

" Capitalize.
nnoremap gu gUiw`]

" Clear highlight.
nnoremap <ESC><ESC> :nohlsearch<CR>:match<CR>

" Easily macro.
nnoremap @@ @a

" Search.
nnoremap ;n  ;
nnoremap ;m  ,
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
" Functions:"{{{
"
function! s:my_on_filetype() "{{{
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
"}}}

"-----------------------------------------------------------------------------
" Platform depends: "{{{
"
" Change colorscheme.
" Don't override colorscheme.
if !exists('g:colors_name') && !has('gui_running')
  colorscheme elflord
endif

set shell=zsh
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

