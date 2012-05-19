# ~/.bash_profile: executed by bash for login shells.

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

# User specific environment and startup programs

case $OSTYPE in
  darwin*)
    ;;
  linux*)
    ;;
  cygwin*)
    export PATH
    unset USERNAME
    [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
    ;;
esac

