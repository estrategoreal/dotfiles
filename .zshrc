# .zshrc

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
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'

precmd () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

if [ -f ~/.zsh.d/auto-fu.zsh ]; then
  source ~/.zsh.d/auto-fu.zsh
  function zle-line-init () {
    auto-fu-init
  }
  zle -N zle-line-init
  zstyle ':completion:*' completer _oldlist _complete
  zstyle ':auto-fu:var' postdisplay $''
fi

[ -f ~/.zsh.d/git-completion.sh ] && source ~/.zsh.d/git-completion.sh

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
    ;;
  linux*)
    ;;
  cygwin*)
    ;;
esac

[ -f ~/.zsh_work ] && source ~/.zsh_work

# Source global definitions

export PROMPT="%F{magenta}%~
%F{cyan}%n@%m%f%% "
export RPROMPT="%1(v|%F{green}%1v%f|)"

case $OSTYPE in
  darwin*)
    export PATH=$PATH:/usr/local/sbin
    ;;
  linux*)
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
    ;;
  cygwin*)
    export CYGWIN=nodosfilewarning
    export PATH=/usr/local/share/vim:/usr/local/share/git-svn-clone-externals:$PATH
    export LIBRARY_PATH=/lib:/lib/w32api:/usr/local/lib
    export TCL_LIBRARY=/usr/share/tcl8.4
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
    ;;
esac

