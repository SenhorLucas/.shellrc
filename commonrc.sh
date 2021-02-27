# =========================================
# If not running interactively, do nothing.
# =========================================
case $- in              # $- is the current shell options. e.g. himBHs
    *i*) ;;             # `i` indicates interactive mode.
      *) return;;
esac

# VCC specific shortcuts not commited to github
include() {
    [[ -f "$1" ]] && source "$1"
}
include ~/.shellrc/vcc.sh

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

# CTags
# Use Universal CTags instead of GNU CTags.
# snap install universal-ctags
alias ctags=/snap/universal-ctags/current/universal-ctags-wrapper

# Add alert at the end of long running commands:
# cmake; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

function install_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
}
[[ -d ~/.fzf ]] || install_fzf

# ========
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_DEFAULT_OPTIONS='-m --height 50% --border'
