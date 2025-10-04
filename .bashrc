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

function screenrecord() {
	if [[ -z "$1" ]]; then
		echo "Usage: ${FUNCNAME[0]} [duration_in_seconds] [output_filename]";
		echo "Example: ${FUNCNAME[0]} 25 output.mp4";
		return 2;
	fi

	local duration="$1"
	local output="${2:-output.mp4}"

	# check audio output with:
	#   pactl list sources | grep -A 5 "Name:"
	ffmpeg -video_size 1920x1080 -framerate 24 -thread_queue_size 2048 \
		-draw_mouse 0 -f x11grab -i :1+1920,0 \
		-thread_queue_size 2048 -f pulse -i bluez_output.AC_80_0A_75_AC_B8.1.monitor \
		-t "$duration" -c:v libx264 -preset ultrafast -crf 0 -c:a aac "$output"
}

function ffmpeg_trim() {
	if [[ -z "$1" ]]; then
		echo "Usage: ${FUNCNAME[0]} [start_time] [input_file] [output_file]";
		echo "Example: ${FUNCNAME[0]} 5 output.mp4 final.mp4";
		echo "Example: ${FUNCNAME[0]} 00:01:30 video.mp4 trimmed.mp4";
		echo "Example: ${FUNCNAME[0]} 10  # uses output.mp4 as input, final.mp4 as output";
		return 2;
	fi

	local start_time="$1"
	local input="${2:-output.mp4}"
	local output="${3:-final.mp4}"

	ffmpeg -i "$input" -ss "$start_time" -c:v libx264 -crf 0 -c:a copy "$output"
}

###########
# Exports #
###########

export PS1='\[\033[01;34m\]\W\[\033[00m\]\$ '
