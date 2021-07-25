# `.bashrc`
# =========

# If not running interactively, do nothing.
case $- in              # $- is the current shell options. e.g. himBHs
    *i*) ;;             # `i` indicates interactive mode.
      *) return;;
esac


# Pre-load files
# --------------

source $HOME/lv_shell/common/interactive.sh


# Shell options
# -------------

# Set the editing mode to vi. Default is Emacs, but I've been using Vim lately.
set -o vi

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it.
shopt -s histappend

# If set, the pattern "**" used in a pathname expansion context will match all
# files and zero or more directories and subdirectories.
shopt -s globstar

# Check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize


# Aliases
# -------


# Prompt
# ------

# Colorized prompt if possible.
[[ $TERM =~ .*color.* ]] && color_prompt=yes

# Colors
bold="$(tput bold)"
blue="$(tput setaf 12)"
green="$(tput setaf 2)"
red="$(tput setaf 1)"
reset="$(tput sgr0)"

# Emojis: many won't print with certain fonts.
moj_octupus=$'\xF0\x9F\x90\x99'
moj_snake=$'\xF0\x9F\x90\x8D'
moj_target=$'\xF0\x9F\x8E\xAF'
moj_peach=$'\xF0\x9F\x8D\x91'
moj_aubergine=$'\xF0\x9F\x8D\x86'
moj_cacuts=$'\xF0\x9F\x8C\xB5'
moj_noentry=$'\xE2\x9B\x94'
moj_right=$'\xE2\x96\xB6'
moj_left=$'\xE2\xAC\x85'
moj_up=$'\xE2\xAC\x86'
moj_left=$'\xE2\x97\x80'
# moj_check=$'\xE2\x9C\x85'
# moj_x=$'\xE2\x9D\x8C'
# moj_alien=$'\xF0\x9F\x91\xBE'
# moj_plus=$'\xE2\x9E\x95'

function return_code() {
	local -r code=$?
	(
		{ set +x; } &>/dev/null
		[[ $code != 0 ]] && printf $'%s%s%s%s%s' $bold $red $code $reset
	)
}

# 0 if $PWD is a git repo, non-zero otherize.
function is_git_repo() {
	git rev-parse &>/dev/null
}

# Get current branch in git repo.
function print_git_branch() {
	local -r head_ref="$(cat $(git rev-parse --show-toplevel)/.git/HEAD)"
	printf '%s' " $green"
	if grep -q '^ref: ' <<<$head_ref ; then  # HEAD is not detached
		printf '%s' "$(sed -r 's/^ref: (.*)/\1/' <<<$head_ref)"
	else
		printf '%s' "$(cut -c1-8 <<<$head_ref)"
	fi
	printf '%s' "$reset"
}

# Support function for checkout if certain strings appear in `git status`
function grep_git_status() {
	re_string=$1
	git status 2>&1 | grep "$re_string" &>/dev/null
}

# Print elements found in `git status`
function print_git_status {

	local -r modified=M

	# Number of untracked files
	local -r n_untracked=$(git ls-files --others --exclude-standard | wc -l)
	local -r untracked=${bold}${red}${n_untracked}U${reset}

	local -r ahead=A
	local -r newfile=N
	local -r renamed=R
	local -r deleted=X

	bits=''
	grep_git_status 'modified:' && bits=" $modified$bits"
	grep_git_status 'Untracked' && bits=" $untracked$bits"
	grep_git_status 'Your branch is ahead' && bits=" $ahead$bits"
	grep_git_status 'new file:' && bits=" $newfile$bits"
	grep_git_status 'renamed:' && bits=" $renamed$bits"
	grep_git_status 'deleted:' && bits=" $deleted$bits"
	printf '%s' "$bits"
}

function print_prompt() {
    if is_git_repo; then
		print_git_status
		print_git_branch
	fi
}

if [[ "$color_prompt" ]]; then
	read -r -d '' PS1 <<-'EOF'
		${bold}${blue}\w${reset} \
		$(return_code) \
		$({ set +x; } &>/dev/null; print_prompt)
		\$
	EOF
else
    PS1='\w\n\$ '
fi
unset color_prompt


# Tab completion
# --------------

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Extra tools
# -----------

# VPN: usually includes sensitive data that should not be committed to a
# repository.

# Fuzzy Finder: A wonderful tool for performing fuzzy search on streams.
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash

# Less: make it more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"
