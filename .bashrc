# .bashrc

### OS judge function
## Mac OS X
function is_darwin() {
  [[ $OSTYPE == darwin* ]] && return 0
  return 1
}
## FreeBSD
function is_freebsd() {
  [[ $OSTYPE == freebsd* ]] && return 0
  return 1
}
## Linux
function is_linux() {
  [[ $OSTYPE == linux* ]] && return 0
  return 1
}
## Cygwin
function is_cygwin() {
  [[ $OSTYPE == cygwin* ]] && return 0
  return 1
}
## Msys
function is_msys() {
  [[ $OSTYPE == msys* ]] && return 0
  return 1
}

[ -f ~/.bash.d/git-completion.sh ] && source ~/.bash.d/git-completion.sh
if [ -f ~/.bash.d/z.sh ]; then
  _Z_CMD=j
  source ~/.bash.d/z.sh
  function precmd () {
    _z --add "$(pwd -P)"
  }
fi

# User specific aliases and functions

if is_darwin ; then
  alias ls='ls -G'
elif is_msys ; then
  alias ls='ls --color=auto --show-control-chars'
else
  alias ls='ls --color=auto'
fi
alias ll='ls -l'
alias la='ls -AlF'
alias l='ls -CF'
alias l.='ls -d .[a-zA-Z]*'

alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'

alias ack='ack --asm --cc --cpp'

if is_darwin ; then
  alias ls='ls -G'
  alias ctags='Applications/MacVim.app/Contents/MacOS/ctags "$@"'
  alias vim='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
  alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g "$@"'

  alias fbsd='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm FreeBSD --type gui'
  alias mint='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm Mint13 --type gui'
  alias lmde='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm LMDE --type gui'
  alias rmds='sudo find ~ -name .DS_Store -print -exec rm {} ";"'
elif is_cygwin ; then
  alias open='cygstart'
  alias vim='/usr/bin/vim'
  alias gvim='cyg-wrapper.sh gvim --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr --fork=1'
elif is_msys ; then
  alias vim='/bin/vim'
  alias mingw-search='mingw-get list | grep Package: | grep'
fi
alias vf='gvim +"VimFiler -buffer-name=explorer -simple -toggle"'
alias ide='gvim +"set columns=179" +"VimFiler -buffer-name=explorer -simple -toggle ~/work" +tabnew +TlistOpen +"VimFiler -buffer-name=explorer -split -simple -winwidth=46 -toggle -no-quit"'
alias formc='find . -iregex ".+\.\(c\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4c.cfg --no-backup'
alias formcpp='find . -iregex ".+\.\(c\|cpp\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4cpp.cfg --no-backup'

function udtags() {
  currpath=$(pwd)
  if [[ $# -eq 1 ]] ; then
    cd $1 || exit 1
  fi
  for t in tags GPATH GRTAGS GSYMS GTAGS
  do
    [[ -e $t ]] && rm -f $t
  done
  echo
  echo "updating tags..."
  ctags -R --extra=q
  gtags -v 2>/dev/null
  cd $currpath
}

if is_darwin ; then
  function mkiso() {
    hdiutil makehybrid -o ${1##*/}.iso $1
  }

  function tarbz2() {
    COPYFILE_DISABLE=true tar cjvf $1.tbz --exclude .DS_Store $1
  }
fi

[ -f ~/.bashrc.local ] &&  source ~/.bashrc.local

# Source global definitions

[ -f /etc/bashrc ] && source /etc/bashrc

if is_darwin ; then
  export PS1="\n\[\e[34m\]\u@\h \[\e[35m\]\w$(__git_ps1)\n\[\e[00;37;44m\]How may I serve you, Master?\[\e[00m\]\n$ "
  export PATH=$PATH:/usr/local/sbin
elif is_freebsd ; then
  export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin
elif is_linux ; then
  export PS1="\n\[\e[36m\]\u@\h \[\e[35m\]\w$(__git_ps1)\n\[\e[00;37;44m\]How may I serve you, Master?\[\e[00m\]\n$ "
  PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
elif is_cygwin ; then
  export PS1="\n\[\e[36m\]\u@\h \[\e[35m\]\w$(__git_ps1)\n\[\e[00;37;44m\]How may I serve you, Master?\[\e[00m\]\n$ "
  export LC_MESSAGES=C
  export PATH=/usr/local/share/vim:/usr/local/share/git-svn-clone-externals:$PATH
  export LIBRARY_PATH=/lib:/lib/w32api:/usr/local/lib
  export TCL_LIBRARY=/usr/share/tcl8.4
  PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
elif is_msys ; then
  export LC_MESSAGES=C
  export PS1="\n\[\e[36m\]\u@\h \[\e[35m\]\w$(__git_ps1)\n\[\e[00;37;44m\]How may I serve you, Master?\[\e[00m\]\n$ "
  export PATH=$PATH:/usr/local/share/vim:/usr/local/share/git-svn-clone-externals:/c/git/bin:/c/Python27:/c/Ruby19/bin
fi

