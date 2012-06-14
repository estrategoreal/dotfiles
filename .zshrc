# .zshrc

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

# setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000000 lines of history within the shell and save it to ~/.zsh_history: 
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_reduce_blanks
setopt share_history

# Use modern completion system
autoload -Uz compinit
compinit

setopt auto_pushd
setopt correct
setopt list_packed
setopt no_beep

zstyle ':completion:*' menu select=2
if is_darwin ; then
  zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'ex=31'
elif is_linux || is_cygwin ; then
  zstyle ':completion:*' list-colors 'di=1;34'
fi
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'

precmd() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#if [ -f ~/.zsh.d/auto-fu.zsh ]; then
#  source ~/.zsh.d/auto-fu.zsh
#  function zle-line-init () {
#    auto-fu-init
#  }
#  zle -N zle-line-init
#  zstyle ':completion:*' completer _oldlist _complete
#  zstyle ':auto-fu:var' postdisplay $''
#fi

#[ -f ~/.zsh.d/git-completion.sh ] && source ~/.zsh.d/git-completion.sh

# User specific aliases and functions

if is_darwin ; then
  alias ls='ls -G'
elif is_linux || is_cygwin ; then
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
  alias ctags='/Applications/MacVim.app/Contents/MacOS/ctags "$@"'
  alias vi='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
  alias vim='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
  alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g "$@"'
  alias vf='gvim -c "VimFiler -buffer-name=explorer -simple -toggle"'
  alias ide='gvim -c "set columns=204" -c Tlist -c VimShell -c vsp -c VimFiler'

  alias bsd='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm FreeBSD --type gui'
  alias mint='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm Mint12 --type gui'
  alias lmde='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm LMDE --type gui'
  alias rmds='sudo find ~ -name .DS_Store -print -exec rm {} ";"'
elif is_linux || is_freebsd ; then
  alias vf='gvim -c "VimFiler -buffer-name=explorer -simple -toggle"'
  alias formc='find . -iregex ".+\.\(c\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4c.cfg --no-backup'
  alias formcpp='find . -iregex ".+\.\(c\|cpp\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4cpp.cfg --no-backup'
elif is_cygwin ; then
  alias open='cygstart'
  alias vim='/usr/bin/vim'
  alias gvim='cyg-wrapper.sh gvim --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr --fork=1'
  alias vf='cyg-wrapper.sh gvim --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr --fork=1 -c "VimFiler -buffer-name=explorer -simple -toggle"'
  alias ide='cyg-wrapper.sh gvim --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr --fork=1 +"set columns=153" +"VimFiler -buffer-name=explorer -simple -toggle c:/Development" +tabnew +TlistOpen +"VimFiler -buffer-name=explorer -split -simple -winwidth=35 -toggle -no-quit"'
  alias formc='find . -iregex ".+\.\(c\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4c.cfg --no-backup'
  alias formcpp='find . -iregex ".+\.\(c\|cpp\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4cpp.cfg --no-backup'
fi

function udtags() {
  currpath=$(pwd)
  if [[ $# -eq 1 ]] ; then
    cd $1 || exit 1
  fi
  for t in tags GPATH GRTAGS GSYMS GTAGS
  do
    [[ -e $t ]] && rm -f $t
  done
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

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Source global definitions

export PROMPT="%F{magenta}%~
%F{cyan}%n@%m%f%% "
export RPROMPT="%1(v|%F{green}%1v%f|)"

if is_darwin ; then
  export PATH=$PATH:/usr/local/sbin
elif is_freebsd ; then
  export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin
elif is_linux ; then
  PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
elif is_cygwin ; then
  export LC_MESSAGES=C
  export CYGWIN=nodosfilewarning
  export PATH=/usr/local/share/vim:/usr/local/share/git-svn-clone-externals:$PATH
  export LIBRARY_PATH=/lib:/lib/w32api:/usr/local/lib
  export TCL_LIBRARY=/usr/share/tcl8.4
  PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi

