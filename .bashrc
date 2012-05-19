# .bashrc

if [ -f ~/.git-completion.sh ]; then
  source ~/.git-completion.sh
fi

# User specific aliases and functions

alias ll='ls -l'
alias la='ls -AlF'
alias l='ls -CF'
alias l.='ls -d .[a-zA-Z]*'

alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'

alias ack='ack --asm --cc --cpp'

case $OSTYPE in
  darwin*)
    alias ls='ls -G'
    alias ctags='Applications/MacVim.app/Contents/MacOS/ctags "$@"'
    alias vi='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
    alias vim='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
    alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g "$@"'
    alias exp='gvim -c VimFiler'
    alias ide='gvim -c "set columns=204" -c Tlist -c VimShell -c vsp -c VimFiler'
    
    alias mint='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm Mint12 --type gui'
    alias lmde='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm LMDE --type gui'
    alias rmds='sudo find ~ -name .DS_Store -print -exec rm {} ";"'
    ;;
  linux*)
    alias ls='ls --color=auto'
    alias exp='gvim -c "VimFiler -buffer-name=explorer -simple -toggle"'
    alias formc='find . -iregex ".+\.\(c\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4c.cfg --no-backup'
    alias formcpp='find . -iregex ".+\.\(c\|cpp\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4cpp.cfg --no-backup'
    ;;
  cygwin*)
    alias ls='ls --color=auto'
    alias open='cygstart'
    alias vim='/usr/bin/vim'
    alias gvim='cyg-wrapper.sh gvim --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr --fork=1'
    alias exp='cyg-wrapper.sh gvim --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr --fork=1 -c "VimFiler -buffer-name=explorer -simple -toggle"'
    alias formc='find . -iregex ".+\.\(c\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4c.cfg --no-backup'
    alias formcpp='find . -iregex ".+\.\(c\|cpp\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4cpp.cfg --no-backup'
    ;;
esac

function udtags {
  currpath=$(pwd)
  if [ $# -eq 1 ]; then
    cd $1 || exit 1
  fi
  if [ -e tags ]; then
    rm -f tags
  fi
  ctags -R --extra=q
  if [ -e GPATH ]; then
    rm -f GPATH
  fi
  if [ -e GRTAGS ]; then
    rm -f GRTAGS
  fi
  if [ -e GSYMS ]; then
    rm -f GSYMS
  fi
  if [ -e GTAGS ]; then
    rm -f GTAGS
  fi
  echo
  echo "updating tags..."
  gtags -v 2>/dev/null
  cd $currpath
}

case $OSTYPE in
  darwin*)
    function mkiso {
      hdiutil makehybrid -o ${1##*/}.iso $1
    }

    function tarbz2 {
      COPYFILE_DISABLE=true tar cjvf $1.tbz --exclude .DS_Store $1
    }
  linux*)
    ;;
  cygwin*)
    ;;
esac

if [ -f ~/.bash_work ]; then
  source ~/.bash_work
fi

# Source global definitions

if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

case $OSTYPE in
  darwin*)
    export PS1="\n\[\e[34m\]\u@\h \[\e[35m\]\w$(__git_ps1)\n\[\e[00;37;44m\]How may I serve you, Master?\[\e[00m\]\n$ "
    export PATH=$PATH:/usr/local/sbin
    ;;
  linux*)
    export PS1="\n\[\e[36m\]\u@\h \[\e[35m\]\w$(__git_ps1)\n\[\e[00;37;44m\]How may I serve you, Master?\[\e[00m\]\n$ "
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
    ;;
  cygwin*)
    export PS1="\n\[\e[36m\]\u@\h \[\e[35m\]\w$(__git_ps1)\n\[\e[00;37;44m\]How may I serve you, Master?\[\e[00m\]\n$ "
    export PATH=/usr/local/share/vim:$PATH
    export LIBRARY_PATH=/lib:/lib/w32api:/usr/local/lib
    export TCL_LIBRARY=/usr/share/tcl8.4
    ;;
esac

