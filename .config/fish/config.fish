# config.fish

### OS judge function
set OSTYPE (uname)
## macOS
function is_darwin
  test $OSTYPE = Darwin; and return 0
  return 1
end
## FreeBSD
function is_freebsd
  test $OSTYPE = FreeBSD; and return 0
  return 1
end
## Linux
function is_linux
  test $OSTYPE = Linux; and return 0
  return 1
end
## Cygwin
function is_cygwin
  test (string sub -s 1 -l 5 $OSTYPE) = MINGW; and return 0
  return 1
end
## Msys
function is_msys
  test (string sub -s 1 -l 4 $OSTYPE) = MSYS; and return 0
  return 1
end

set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

bind \cf 'forward-word'

# User specific aliases and functions

if is_freebsd
  alias ls 'ls -G'
else if is_msys
  alias ls 'ls --color=auto --show-control-chars'
else
  alias ls 'ls --color=auto'
end
alias ll 'ls -l'
alias la 'ls -AlF'
alias l 'ls -CF'
alias l. 'ls -d .*'

alias cp 'cp -i'
alias rm 'rm -i'
alias mv 'mv -i'

if is_darwin
  alias vim '/Applications/MacVim.app/Contents/MacOS/Vim'
  alias gvim '/Applications/MacVim.app/Contents/MacOS/Vim -g'

  alias debian '/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm Debian --type gui'
  alias fbsd '/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm FreeBSD --type gui'
  alias mint '/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm Mint --type gui'
  alias rmds 'sudo find ~ -name .DS_Store -print -exec rm {} ";"'
else if is_cygwin
  alias open 'cygstart'
  alias vim '/usr/bin/vim'
  alias gvim 'cyg-wrapper.sh gvim --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr --fork=1'
else if is_msys
  alias vim '/usr/bin/vim'
  alias conv 'iconv -f CP932 -t UTF-8'
end
alias vf 'gvim +"VimFiler -buffer-name=explorer -simple -toggle"'
alias formc 'find . -iregex ".+\.\(c\|h\)\$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4c.cfg --no-backup'
alias formcpp 'find . -iregex ".+\.\(c\|cpp\|h\)\$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4cpp.cfg --no-backup'

function parse_git_branch
  set -l branch (git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/\1/')

  echo (set_color green)$branch(set_color normal)
end

function fish_prompt
  set -l git_dir (git rev-parse --git-dir 2> /dev/null)
  set prompt (set_color magenta)(prompt_pwd)

  echo $prompt
  echo (set_color cyan)(whoami)'@'(hostname | cut -d . -f 1)(set_color normal)'> '
end

function fish_right_prompt
  set -l git_dir (git rev-parse --git-dir 2> /dev/null)

  if test -n "$git_dir"
    echo [(parse_git_branch)]
  end
end

function ide
  set len (count $argv)
  if test $len -ge 1
    set name $argv[1]
    if is_msys
      set s (string sub -s 1 -l 1 $name)
      if test $s = "/"
        set name "/msys64$argv[1]"
      end
    end
    gvim +"set columns=179" +"VimFiler -buffer-name=explorer -toggle ~" +"tabedit $name" +TagbarOpen +"VimFilerCurrentDir -create -explorer -winwidth=48" +"wincmd l" &
  else
    gvim +"set columns=179" +"VimFiler -buffer-name=explorer -toggle ~" +tabnew +TagbarOpen +"wincmd h" +"VimFilerCurrentDir -create -explorer -winwidth=48" &
  end
end

function gitarc
  set len (count $argv)
  if test $len -lt 1
    return
  end
  git archive --format=tar --prefix=$argv[1]/ HEAD | bzip2 > $argv[1].tbz
end

function udtags
  set currpath (pwd)
  set len (count $argv)
  if test $len -eq 1
    cd $argv[1]; or return
  end
  for t in tags GPATH GRTAGS GSYMS GTAGS
    test -e $t; and rm -f $t
  end
  echo "updating tags..."
  ctags -R --languages=c,c++ --extra=+q
  gtags -v 2>/dev/null
  cd $currpath
end

if is_darwin
  function mkiso
    set name (string match -r '[^/]*$' $argv[1])
    hdiutil makehybrid -o $name.iso $argv[1]
  end

  function tarbz2
    env COPYFILE_DISABLE=true tar cjvf $argv[1].tbz --exclude .DS_Store $argv[1]
  end
else if is_freebsd
  function udpkg
    sudo portsnap fetch update
    sudo pkg_replaece -V
    sudo pkg_replaece -aR -m "BATCH=yes"
    sudo pkg_replaece -V
    sudo freebsd-update fetch
    sudo freebsd-update install
  end
end

test -f $HOME/.config/fish/local.fish; and source $HOME/.config/fish/local.fish

# Source global definitions

if test -z $TMUX
  if is_darwin
    set -gx PATH (brew --prefix coreutils)/libexec/gnubin /usr/local/bin /usr/local/sbin /usr/sbin /sbin $PATH
  else if is_freebsd
    set -gx PATH $PATH /sbin /usr/sbin /usr/local/sbin
  else if is_linux
    set -gx PATH $PATH /sbin /usr/sbin /usr/local/sbin
  else if is_cygwin
    set -gx PATH=$PATH /usr/local/share/vim /usr/local/share/git-svn-clone-externals
  else if is_msys
    set -gx PATH $PATH /usr/local/share/vim /usr/local/share/git-svn-clone-externals /c/Ruby/bin /c/Python /c/Python/Scripts /c/Go/bin
  end

  set -gx GOPATH $HOME/.go
  set -gx GOROOT_BOOTSTRAP $GOPATH/go1.4
  set -gx PATH $PATH $GOPATH/bin
end

if is_cygwin
  set -gx LC_MESSAGES C
  set -gx CYGWIN nodosfilewarning
  set -gx LIBRARY_PATH /lib:/lib/w32api /usr/local/lib
  set -gx TCL_LIBRARY /usr/share/tcl8.4
else if is_msys
  set -gx LC_MESSAGES C
  set -gx XDG_CONFIG_HOME $HOME/.config # for neovim
end

# if is_darwin
#   set brew_completion (brew --prefix 2>/dev/null)/etc/bash_completion
#   if $staus -eq 0; and test -f "$brew_completion"
#     source $brew_completion
#   fi
#
#   if test -f (brew --prefix)/etc/brew-wrap
#     source (brew --prefix)/etc/brew-wrap
#   end
# end
if is_darwin; or is_linux; or is_cygwin
  set -gx PATH $HOME/.anyenv/bin $PATH
end
if test -x "`which anyenv`"
  eval "(anyenv init -)"
end

test -f $HOME/.config/fish/tmux.fish; and source $HOME/.config/fish/tmux.fish

