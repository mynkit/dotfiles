# nvim
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"

# エイリアスの設定
# ls（カラー表示）
alias ls='ls -G'
alias ll='ls -lG'
alias la='ls -laG'

# autoload -Uz colors colors

# Git

source /data/data/com.termux/files/home/../usr/etc/bash_completion.d/git-completion.bash
source /data/data/com.termux/files/home/../usr/etc/bash_completion.d/git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
# setopt PROMPT_SUBST ; PS1='[%~ %F{green}$(__git_ps1 " %s")%f]\$ '

PS1='\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\n\$ '


# golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

