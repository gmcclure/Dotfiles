### env vars
export CLICOLOR_FORCE=1
export EDITOR='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LD_FLAGS="-L/usr/local/opt/libffi/lib"
export PATH="/Users/gmcclure/Bin:/usr/local/sbin:/Users/gmcclure/Library/Python/2.7/bin:$PATH"
export PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"
export PROMPT_DEVICE_COLOR="$(tput bold)$(tput setaf 5)"
export PROMPT_DIR_COLOR="$(tput bold)$(tput setaf 9)"
export PROMPT_GIT_STATUS_COLOR="$(tput bold)$(tput setaf 2)"
export PROMPT_USER_COLOR="$(tput bold)$(tput setaf 12)"
export TERM=xterm-256color

### #aliases
alias e="$EDITOR"
alias edit="$EDITOR"
alias gpm="git push -u origin master"
alias gst="git status"
alias less='less -R'
alias ls='exa'
alias l='exa -al'
alias ll='exa -l'
alias mkdir='mkdir -p'
alias tree='tree -C'
alias vimbash='edit ~/.bashrc'
alias love='/Applications/love.app/Contents/MacOS/love'
alias sbcl='rlwrap /usr/local/bin/sbcl'

#### shims and inits

# if which tmux >/dev/null 2>&1; then
#     #if not inside a tmux session, and if no session is started, start a new session
#     test -z "$TMUX" && (tmux attach || tmux new-session)
# fi

if [ -f /usr/local/etc/bash_completion ]; then source /usr/local/etc/bash_completion; fi

# Run twolfson/sexy-bash-prompt
if ! [ -n "$EMACS" ]; then
    . ~/.bash_prompt
else
    export PS1="[\u: \W] "
fi

#### special functions

# Enable global pip3 functionality
gpip() {
    PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}

source /usr/local/etc/profile.d/z.sh

# eval "$(direnv hook bash)"
eval "$(rbenv init -)"
