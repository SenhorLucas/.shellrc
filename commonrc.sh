# =========================================
# If not running interactively, do nothing.
# =========================================
case $- in              # $- is the current shell options. e.g. himBHs
    *i*) ;;             # `i` indicates interactive mode.
      *) return;;
esac


# ================
# Default Settings
# ================
# Start tmux as by default
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach -t default || tmux new -s default
fi
# History
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


# =======
# Aliases
# =======
# CSP project aliases
source ~/.shellrc/csp_shortcuts.sh

# Handy fily system locations
alias csp="cd ~/repos/csp"
alias sdk="cd ~/repos/csp/products/sdk"
alias tools="cd ~/repos/csp/tools"
alias products="cd ~/repos/csp/products"
alias components="cd ~/repos/csp/components"

# Enable colors for certain common commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ls
alias la='ls -a'
alias ll='ls -alF'
alias l='ls -CF'

# User repo with python3
alias repo3='~/repos/csp/.repo/repo/repo'

# Add alert at the end of long running commands:
# cmake; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Gerrit
alias gerrit='ssh cspgerrit gerrit'


# ================
# Custom Functions
# ================

# Turn on/off secondary monitor
function monitor_on {
    xrandr --output DVI-I-1-1 --auto --left-of DVI-I-2-2 --output DVI-I-2-2 --auto --left-of eDP-1
}

function monitor_off {
    xrandr --output DVI-I-1-1 --off --output DVI-I-2-2 --off
}

# Connect to volvo VPN using f5fcp
function vpn {
    bash ./vpn
}

# Connect to docker artifactory repo
function docker_login {
    docker login -u lviana swf1.artifactory.cm.volvocars.biz:5002
}
