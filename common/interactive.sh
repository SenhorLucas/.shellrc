#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
LV_SHELL_DIR=

# VCC specific shortcuts not commited to github
[[ -f vcc.sh ]] && source vcc.sh



# Linking files together
# ----------------------

[[ -f $HOME/lv_shell/common/env/secrets.sh ]] && source $HOME/lv_shell/common/secrets.sh
source $HOME/lv_shell/common/env.sh

function link_files() {
	# Vim
	if [[ ! -f "$HOME"/.vimrc ]]; then
		cat <<-EOF "$HOME"/.vimrc
			source "$HOME"/lv_shell/vim/vimrc
		EOF
	fi


	# Tmux
	if [[ ! -f "$HOME"/.tmux.conf ]]; then
		cat <<-EOF "$HOME"/.tmux.conf
			source-file "$HOME"/lv_shell/tmux/tmux.conf
		EOF
	fi
}

# Start tmux as by default
# if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
#   tmux attach -t default || tmux new -s default
# fi


# Aliases
# -------

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
# alias ctags=/snap/universal-ctags/current/universal-ctags-wrapper

# Add alert at the end of long running commands:
# cmake; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# Custom functions
# ----------------

# Turn on/off secondary monitor.
function monitor_on {
    xrandr --output DVI-I-1-1 --auto --left-of DVI-I-2-2 --output DVI-I-2-2 --auto --left-of eDP-1
}

function monitor_off {
    xrandr --output DVI-I-1-1 --off --output DVI-I-2-2 --off
}


# 3rd party
# ---------
function install_fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    ~/.fzf/install
}
[[ -d $HOME/.fzf ]] || install_fzf

rg --version &>/dev/null && export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_DEFAULT_OPTIONS='-m --height 50% --border'


# Just for reference
# ------------------

# DBus templates
function dbus_list_names() {
    dbus-send --session --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.ListNames
}

function dbus_get_pid() {
    local $socket_name=$1
    dbus-send --session --print-reply --dest=org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus.GetConnectionUnixProcessID "string:$socket_name"
}
