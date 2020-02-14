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

## Msys
function is_msys() {
  [[ $OSTYPE == msys* ]] && return 0
  return 1
}

export LANG=en_US.UTF-8

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

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
setopt PROMPT_SUBST
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'

_vcs_precmd () { vcs_info }
add-zsh-hook precmd _vcs_precmd

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

if [ -d ~/.zsh.d/zsh-completions/src ]; then
  fpath=(~/.zsh.d/zsh-completions/src $fpath)
fi

if [ -f ~/.zsh.d/z/z.sh ]; then
  _Z_CMD=j
  source ~/.zsh.d/z/z.sh
  function precmd () {
    _z --add "$(pwd -P)"
  }
fi

# User specific aliases and functions

if is_freebsd ; then
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

if is_darwin ; then
  alias vim='/Applications/MacVim.app/Contents/MacOS/Vim "$@"'
  alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g "$@"'

  alias debian='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm Debian --type gui'
  alias fbsd='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm FreeBSD --type gui'
  alias manjaro='/Applications/VirtualBox.app/Contents/MacOS/VBoxManage startvm Manjaro --type gui'
  alias rmds='sudo find ~ -name .DS_Store -print -exec rm {} ";"'
elif is_cygwin ; then
  alias open='cygstart'
  alias vim='/usr/bin/vim'
  alias gvim='cyg-wrapper.sh gvim --binary-opt=-c,--cmd,-T,-t,--servername,--remote-send,--remote-expr --fork=1'
elif is_msys ; then
  alias vim='/usr/bin/vim'
  alias conv='iconv -f CP932 -t UTF-8'
fi
alias vf='gvim +"VimFiler -buffer-name=explorer -simple -toggle"'
alias formc='find . -iregex ".+\.\(c\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4c.cfg --no-backup'
alias formcpp='find . -iregex ".+\.\(c\|cpp\|h\)$" -type f -print0 | xargs -0 uncrustify -c ~/.uncrustify4cpp.cfg --no-backup'

function ide() {
  if [[ $# -ge 1 ]] ; then
    name=$1
    if is_msys ; then
      if [[ ${name:0:1} = "/" ]]; then
        name="/msys64$1"
      fi
    fi
    gvim +"set columns=179" +"VimFiler -buffer-name=explorer -toggle ~" +"tabedit $name" +TagbarOpen +"VimFilerCurrentDir -create -explorer -winwidth=48" +"wincmd l"
  else
    gvim +"set columns=179" +"VimFiler -buffer-name=explorer -toggle ~" +tabnew +TagbarOpen +"wincmd h" +"VimFilerCurrentDir -create -explorer -winwidth=48"
  fi
}

function gitarc() {
  if [[ $# -lt 1 ]] ; then
    return
  fi
  git archive --format=tar --prefix=$1/ HEAD | bzip2 > $1.tbz
}

function udtags() {
  currpath=$(pwd)
  if [[ $# -eq 1 ]] ; then
    cd $1 || return
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
    find $1 -name .DS_Store -print -exec rm {} ";"
    hdiutil makehybrid -iso -udf -o ${1##*/}.iso $1
  }

  function tarbz2() {
    COPYFILE_DISABLE=true tar cjvf $1.tbz --exclude .DS_Store $1
  }
elif is_freebsd ; then
  function udpkg() {
    sudo portsnap fetch update
    sudo pkg_replaece -V
    sudo pkg_replaece -aR -m "BATCH=yes"
    sudo pkg_replaece -V
    sudo freebsd-update fetch
    sudo freebsd-update install
  }
fi

[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Source global definitions

export PROMPT='%F{magenta}%~
%F{cyan}%n@%m%f% $ '
export RPROMPT='%F{green}${vcs_info_msg_0_}%f'

if [[ -z $TMUX ]]; then
  if is_darwin ; then
    export PATH=$(brew --prefix coreutils)/libexec/gnubin:/usr/local/sbin:$PATH
  elif is_freebsd ; then
    export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin
  elif is_linux ; then
    export PATH=$PATH:/sbin:/usr/sbin:/usr/local/sbin
  elif is_cygwin ; then
    export PATH=$PATH:/usr/local/share/vim:/usr/local/share/git-svn-clone-externals
  elif is_msys ; then
    export PATH=$PATH:/usr/local/share/vim:/usr/local/share/git-svn-clone-externals:/c/Ruby/bin:/c/Python:/c/Python/Scripts:/c/Go/bin
  fi

  if [ -d $HOME/.anyenv ];then
    export PATH=$PATH:$HOME/.anyenv/bin
    eval "$(anyenv init -)"
  fi

  export GOPATH=$HOME/.go
  export GOROOT_BOOTSTRAP=$GOPATH/go1.4
  export PATH=$PATH:$GOPATH/bin
fi

if is_cygwin ; then
  export LC_MESSAGES=C
  export CYGWIN=nodosfilewarning
  export LIBRARY_PATH=/lib:/lib/w32api:/usr/local/lib
  export TCL_LIBRARY=/usr/share/tcl8.4
elif is_msys ; then
  export LC_MESSAGES=C
  export XDG_CONFIG_HOME=$HOME/.config  # for neovim
fi

if is_darwin ; then
  brew_completion=$(brew --prefix 2>/dev/null)/share/zsh/site-functions
  if [ $? -eq 0 ] && [ -d "$brew_completion" ];then
    fpath=($brew_completion $fpath)
  fi
  autoload -U compinit
  compinit

  if [ -f $(brew --prefix)/etc/brew-wrap ];then
    source $(brew --prefix)/etc/brew-wrap
  fi
fi

[ -f ~/.zshrc.tmux ] && source ~/.zshrc.tmux

