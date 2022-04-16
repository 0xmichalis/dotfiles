# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

alias ll='ls -Alh'
alias kc='kubectl'
alias dk='docker kill $(docker ps -q)'
alias rmhist='cat /dev/null > ~/.bash_history && history -c && exit'
alias rg='rg --hidden'
alias now='date +%s'

function drm() {
	if [[ -z "$1" ]]; then
			echo "Usage: $0 [image_regexp]";
			exit 1;
	fi
	docker rmi -f $(docker images | grep $1 | awk '{print $3}')
}

export GOROOT=/usr/lib/golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
