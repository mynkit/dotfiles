# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
# ghcup
. $HOME/.ghcup/env

# nvim
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"

# エイリアスの設定
# ls（カラー表示）
alias ls='ls -G'
alias ll='ls -lG'
alias la='ls -laG'

autoload -Uz colors colors

# Git
fpath=(~/.zsh $fpath)
if [ -f ${HOME}/.zsh/git-completion.zsh ]; then
       zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.zsh
fi
if [ -f ${HOME}/.zsh/git-prompt.sh ]; then
       source ${HOME}/.zsh/git-prompt.sh
fi
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
setopt PROMPT_SUBST ; PS1='[%~ %F{green}$(__git_ps1 " %s")%f]\$ '

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(brew shellenv)"
eval "$(pyenv init --path)"
eval "$(anyenv init -)"

# golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

[[ -s "/Users/keitamiyano/.gvm/scripts/gvm" ]] && source "/Users/keitamiyano/.gvm/scripts/gvm"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/keitamiyano/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/keitamiyano/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/keitamiyano/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/keitamiyano/google-cloud-sdk/completion.zsh.inc'; fi
eval "$(direnv hook zsh)"
