# tmux.fish

function is_exists
  type $argv >/dev/null 2>&1
end
function is_osx
  test "$OSTYPE" = "darwin*"
end
function is_screen_running
  not test -z "$STY"
end
function is_tmux_runnning
  not test -z "$TMUX"
end
function is_screen_or_tmux_running
  is_screen_running || is_tmux_runnning
end
function shell_has_started_interactively
  status --is-interactive
end
function is_ssh_running
  not test -z "$SSH_CONNECTION"
end

function tmux_automatically_attach_session
  if is_screen_or_tmux_running
    not is_exists 'tmux' && return 1

    if is_tmux_runnning
      set_color --bold red
      echo " _____ __  __ _   ___  __ "
      echo "|_   _|  \/  | | | \ \/ / "
      echo "  | | | |\/| | | | |\  /  "
      echo "  | | | |  | | |_| |/  \  "
      echo "  |_| |_|  |_|\___//_/\_\ "
      set_color normal
    else if is_screen_running
      echo "This is on screen."
    end
  else
    if shell_has_started_interactively && not is_ssh_running
      if not is_exists 'tmux'
        echo 'Error: tmux command not found' 2>&1
        return 1
      end

      if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'
        # detached session exists
        tmux list-sessions
        echo -n "Tmux: attach? (y/N/num) "
        read
        if "$REPLY" =~ '^[Yy]$' || "$REPLY" = ''
          if tmux attach-session
            echo "(tmux -V) attached session"
            return 0
          end
        else if "$REPLY" =~ '^[0-9]+$'
          if tmux attach -t "$REPLY"
            echo "(tmux -V) attached session"
            return 0
          end
        end
      end

      if is_osx && is_exists 'reattach-to-user-namespace'
        # on OS X force tmux's default command
        # to spawn a shell in the user's namespace
        set tmux_config (cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
        tmux -f <(echo "$tmux_config") new-session && echo "(tmux -V) created new session supported OS X"
      else
        tmux new-session && echo "tmux created new session"
      end
    end
  end
end
tmux_automatically_attach_session

