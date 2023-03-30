# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

alias ll='ls -Alh'
alias kc='kubectl'
alias dk='docker kill $(docker ps -q)'
alias rmhist='cat /dev/null > ~/.bash_history && history -c && reset'
alias rg='rg --hidden'
alias now='date +%s'

function drm() {
	if [[ -z "$1" ]]; then
		echo "Usage: ${FUNCNAME[0]} [image_regexp]";
		return 2;
	fi
	docker rmi -f $(docker images | grep $1 | awk '{print $3}')
}

function h2d() {
	if [[ -z "$1" ]]; then
		echo "Usage: ${FUNCNAME[0]} [hex]";
		return 2;
	fi
	echo "ibase=16; ${@^^}" | bc;
}

export PS1='\[\033[01;34m\]\W\[\033[00m\]\$ '
