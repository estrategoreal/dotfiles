" An example for a gvimrc file.
" The commands in this are executed when the GUI is started.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2001 Sep 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.gvimrc
"	      for Amiga:  s:.gvimrc
"  for MS-DOS and Win32:  $VIM\_gvimrc
"	    for OpenVMS:  sys$login:.gvimrc

" Make external commands work through a pipe instead of a pseudo-tty
"set noguipty

" set the X11 font to use
" set guifont=-misc-fixed-medium-r-normal--14-130-75-75-c-70-iso8859-1
if has('mac')
  set guifont=Cica:h14,Osaka-Mono:h14
  set antialias
  augroup Transparency
    autocmd!
    autocmd FocusGained * set transparency=10
    autocmd FocusLost * set transparency=50
  augroup END
  if exists('&ambiwidth')
    set ambiwidth=double
  endif
elseif has('win32') || has('win64')
  set guifont=Cica:h12,MeiryoKe_Gothic:h11,MS_Gothic:h11:cSHIFTJIS
  set renderoptions=type:directx,renmode:5

  " Toggle font setting.
  function! FontToggle()
    if &guifont =~ '^Cica'
      set guifont=MeiryoKe_Gothic:h11,MS_Gothic:h11:cSHIFTJIS
    else
      set guifont=Cica:h12
    endif
  endfunction

  nnoremap TF :<C-u>call FontToggle()<CR>

  if has('kaoriya')
    set ambiwidth=auto
  endif
else
  set guifont=Cica\ 11
endif

" Save the setting of window.
set columns=107
let g:save_window_file = expand('~/.vim/vimwinpos')
augroup SaveWindow
  autocmd!
  autocmd VimLeavePre * call s:save_window()
  function! s:save_window()
    let options = [
      \ 'set lines=' . &lines,
      \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
      \ ]
    call writefile(options, g:save_window_file)
  endfunction
augroup END

if filereadable(g:save_window_file)
  execute 'source' g:save_window_file
endif

" Disable menu.vim
set guioptions=Mc

if has('win32') || has('win64')
  gui
  if has('kaoriya')
    augroup Transparency
      autocmd!
      autocmd FocusGained * set transparency=240
      "autocmd FocusLost * set transparency=120
    augroup END
  endif
endif

" Setting of colorscheme.
set background=dark
colorscheme solarized

set ch=2		" Make command line two lines high

set mousehide		" Hide the mouse when typing text

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Only do this for Vim version 5.0 and later.
if version >= 500

  " I like highlighting strings inside C comments
  let c_comment_strings=1

  " Switch on syntax highlighting if it wasn't on yet.
  if !exists("syntax_on")
    syntax on
  endif

  " Switch on search pattern highlighting.
  set hlsearch

  " For Win32 version, have "K" lookup the keyword in a help file
  "if has("win32")
  "  let winhelpfile='windows.hlp'
  "  map K :execute "!start winhlp32 -k <cword> " . winhelpfile <CR>
  "endif

  " Set nice colors
  " background for normal text is light grey
  " Text below the last line is darker grey
  " Cursor is green, Cyan when ":lmap" mappings are active
  " Constants are not underlined but have a slightly lighter background
  "highlight Normal guibg=grey90
  "highlight Cursor guibg=Green guifg=NONE
  "highlight lCursor guibg=Cyan guifg=NONE
  "highlight NonText guibg=grey80
  "highlight Constant gui=NONE guibg=grey95
  "highlight Special gui=NONE guibg=grey95
  "highlight SpecialKey guifg=grey75
  highlight SpecialKey guifg=grey25

endif
