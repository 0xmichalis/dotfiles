# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

###########
# Aliases #
###########

alias ll='ls -Alh'
alias kc='kubectl'
alias docker='podman'
alias dk='docker kill $(docker ps -q)'
alias rmhist='cat /dev/null > ~/.bash_history && history -c && reset'
alias rg='rg --hidden --text --glob "!.yarn/**" --glob "!**/node_modules/**" --glob "!.git/**"'
alias now='date +%s'
alias sys='w && free -hm && df -h'

#############
# Functions #
#############

function runhttp() {
    if [[ -z "$1" ]]; then
        echo "Usage: ${FUNCNAME[0]} [port]";
        return 2;
    fi
    python3 -m http.server "$1"
}

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

function d2h() {
	if [[ -z "$1" ]]; then
		echo "Usage: ${FUNCNAME[0]} [dec]";
		return 2;
	fi
    echo "obase=16; ${@^^}" | bc;
}

function pdfreduce() {
	if [[ -z "$1" || -z "$2" ]]; then
		echo "Usage: ${FUNCNAME[0]} [input.pdf] [output.pdf]";
		return 2;
	fi
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 \
		-dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH \
		-sOutputFile="$2" "$1"
}

###########
# Exports #
###########

export PS1='\[\033[01;34m\]\W\[\033[00m\]\$ '
