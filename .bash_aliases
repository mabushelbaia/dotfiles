# Change Directories
alias ..='cd ../'
alias ...='cd ../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias cdl='cd $1 && ls'
alias mkcd='mkcd_alias(){ mkdir -p "$1" && cd "$1"}'

# List Directory
alias l.='exa -laF --icons --color=always --group-directories-first --ignore-glob=[A-Za-z0-9]*'
alias la='exa -aF --icons --color=always --group-directories-first'
alias ll='exa -lF --icons --color=always --group-directories-first'
alias ls='exa  -F --icons --color=always --group-directories-first'
alias lt='exa -TF --icons --color=always --group-directories-first'
alias ltt='lt --level'
alias ds='exa -TF --grop-directories-first | clipboard'
# Git & Github
alias addall='git add .'
alias pull='git pull origin'
alias push='git push origin'
alias commit='git commit -m'
alias status='git status'

# Flags And Colors
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias free='free -m'
alias df='df -h'
alias cp='cp -i'

# Super privlages
alias docker='sudo docker'
alias docker-compose='sudo docker compose'

# System Commands
alias pong='ping 1.1.1.1 -c4'
alias eip='curl ifconf.me'
alias uu='sudo apt update && sudo apt upgrade -y'

# Extras
alias clipboard='xclip -sel clip'
alias nitch='clear; nitch'
