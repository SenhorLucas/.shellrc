# =========================================
# If not running interactively, do nothing.
# =========================================
case $- in              # $- is the current shell options. e.g. himBHs
    *i*) ;;             # `i` indicates interactive mode.
      *) return;;
esac

# Load commonrc file
source ~/.shellrc/commonrc.sh
# Link ~/.zshrc to ~/.shellrc/zshrc.sh
alias linkrc="ln -lf ~/.shellrc/zshrc.sh ~/.zshrc"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
bindkey -v
PROMPT='%(?.%F{200}√.%F{red}?%?)%f %B%F{211}%~%f%b %# '
# End of lines configured by zsh-newuser-install
