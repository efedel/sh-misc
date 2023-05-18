#!/usr/bin/env bash
# vim: set filetype=sh : (vim modeline for syntax highlighting)                

# ------------------------------------------------------------
# Color definitions for use in prompts etc
# NOTE: all non-printing chars, e.g. stuff in 'man console_codes', need
#       to be wrapped in \[ \] brackets so bash counts line length properly.
# TODO: replace these with tput commands to be OS-independent
BLACK='\[\033[30m\]'
BLUE='\[\033[34m\]'
GREEN='\[\033[32m\]'
CYAN='\[\033[36m\]'
RED='\[\033[31m\]'
PURPLE='\[\033[35m\]'
BROWN='\[\033[33m\]'
LIGHTGRAY='\[\033[37m\]'
DARKGRAY='\[\033[1;30m\]'
LIGHTBLUE='\[\033[1;34m\]'
LIGHTGREEN='\[\033[1;32m\]'
LIGHTCYAN='\[\033[1;36m\]'
LIGHTRED='\[\033[1;31m\]'
LIGHTPURPLE='\[\033[1;35m\]'
YELLOW='\[\033[1;33m\]'
WHITE='\[\033[1;37m\]'
BG_BLACK='\[\033[40m\]'
BG_BLUE='\[\033[44m\]'
BG_GREEN='\[\033[42m\]'
BG_CYAN='\[\033[46m\]'
BG_RED='\[\033[41m\]'
BG_PURPLE='\[\033[45m\]'
BG_BROWN='\[\033[43m\]'
BG_WHITE='\[\033[47m\]'
BOLD='\[\033[1m\]'
BLINK='\[\033[5m\]'
REVERSE='\[\033[7m\]'
NC='\[\033[0m\]'              # No Color

# -------------------------------------------------------------------
# calc : calculate an expression (wrapper for bc)
function calc () {
	        bc << EOF
$*
EOF
}

# -------------------------------------------------------------------
# plot : plot arbitrary list of numbers with gnuplot
#        Example:
# wc -l  * 2>/dev/null | awk '{print $1}' | sort -n | plot with lines
function plot () {
	        ( echo plot \'-\' "$*"; cat -) | `which gnuplot` -persist
}

# -------------------------------------------------------------------
# ifind : case insensitive find from the current directory
function ifind () {
        if [ -z "$1" ]
        then
                echo Usage: ifind pattern
                return 1
        fi

        find . -iname \*$*\*
}


# ------------------------------------------------------------
# error_exit : exit shell writing a message to STDERR and returning nonzero
error_exit () {
	code=1
	[ 1 -le $# ] && msg="$1"

	msg='Unknown error'
	[ 2 -le $# ] && code="$2"
	
	echo $msg > /dev/stderr
	exit $code
}

# ------------------------------------------------------------
# chmod_x_dir : Recursively chmod a+x all directories in specified path
chmod_x_dir () {
	if [ -z "$1" ] 
	then
		echo Usage: chmod_x_dir path
		return 1
	fi

	find $1 -type d -exec chmod a+x \{\} \;
	return $?
}

# ------------------------------------------------------------
# tarcp : use tar to copy files, preserving ownership and permissions
tarcp () {
	if [ -z "$1" -o -z "$2" ] 
	then
		echo Usage: tarcp src dest
		return 1
	fi

	tar cpf - $1 | (cd $2 && tar xvpBf -)
	return $?
}

# ------------------------------------------------------------
# diff-stdout : Run the stdout from two commands through diff.
# Usage: diff-stdout 'first command' 'second command'
diff-stdout () {
	diff -B <($1) <($2)
}

# ------------------------------------------------------------
# dirdiff : Show the difference between the contents of two directories.
#           Non-recursive.
dirdiff () {
	diff -yB -W 80 <(ls -1 --color=never $1) <(ls -1 --color=never $2)
}

# ------------------------------------------------------------
# ssh-auth : add server to ssh-agent if it is not already present
# Usage: ssh-auth server-name
ssh-auth () {
	# Pattern assumes server key is in ~/.ssh/server-name
	pat=".ssh/$1 "

	# If server name already exists in ssh-agent, return success
	[ 0 -eq `ssh-add -l | grep $pat | wc -l` ] || return 0

	# ... else return result of ssh-add
	ssh-add ~/.ssh/$1
	return $?
}

# ------------------------------------------------------------
# zombies : the evil dead
zombies () {
	ps hr -Nos | awk '$1=="Z" {print $1}'
}

# ------------------------------------------------------------
# truncate path: returns $1 truncated to $2 chars, prefixed with ...
truncate_path () {
	if [ -z "$1" -o -z "$2" ] 
	then
		echo Usage: truncate_path path length
		return 1
	fi

	if [ ${#1} -le $2 ] 
	then 
		echo $1
	else 
		local offset=$(( ${#1} - $2 + 3 ))
		echo "...${1:$offset:$2}"
	fi

}

# ------------------------------------------------------------
# user_prompt: returns "user@host:path", where path is truncated to 1/3 
# of the screen size, and the string is RED if UID is 0 (root login).
user_prompt () {
	local prompt='\u@\h:`truncate_path "$PWD" $((COLUMNS/3))`'
	if [ $UID -eq 0 ]
	then
		# Highlight username and path in red if user is root
		prompt="${RED}${prompt}${NC}"
	fi

	echo $prompt
}

# ------------------------------------------------------------
# xterm_title: sets the title of the xterm to the arguments passed.
xterm_title () {
	echo -e "\[\033]0;$*\007\]"
}

# ------------------------------------------------------------
# xterm_exec: sets the title of the xterm to args, then executes args.
#             useful for window manager menus.
xterm_exec () {
	xterm_title $*
	$*
}

# ------------------------------------------------------------
# alt_wm: run an alternate window manager in a new XServer session.
# Allows two XSessions to be run concurrently. Useful for testing
# new window managers that are buggy, e.g. Beryl or E17.
alt_wm () {
	if [ -z "$1" ] 
	then
		echo Usage: alt_wm path [screen]
		return 1
	fi

	SCREEN_NUM=$2
	[ -z "$SCREEN_NUM" ] && SCREEN_NUM="1"

	startx $1 -- :${SCREEN_NUM}
        #xinit $1 -- :${SCREEN_NUM}
}

# ------------------------------------------------------------
# base_convert : Performs conversion between different numeric bases.
# Requires bc.
base_convert () {
	if [ $# -lt 3 ]
	then
		echo Usage: base_conv inbase outbase value
		return 0
	fi

	inbase="$1"
	outbase="$2"
	value="$3"
	echo "ibase=${inbase};obase=${outbase};$value" | bc
}

# Decimal to Hexadecimal
dec2hex () {
	base_convert 10 16 $1
}
	
# Decimal to Octal
dec2oct () {
	base_convert 10 8 $1
}

# Hexadecimal to Octal
hex2oct () {
	base_convert 16 8 $1
}

# Hexadecimal to Decimal
hex2dec () {
	base_convert 16 'A' $1
}

# Octal to Decimal
oct2dec () {
	base_convert 8 12 $1
}

# Octal to Hexadecimal
oct2hex () {
	base_convert 8 20 $1
}

# ------------------------------------------------------------
# die : Exit with an error status (1) and print the provided error message.
# Useful in shell scripting, e.g. 
# 	[ -f '.lock' ] && die 'Lock file exists' 
die () {
	echo $1
	exit 1
}

# ------------------------------------------------------------
# mv2backup : Append the suffix 'backup-TS' the specified filename, where TS is
# the timestamp in format 'YYYY.MM.DD.hhmm.ss'. This is useful in shell scripts
# to quickly create a timestamped-backup of a file before overwriting it.
mv2backup () {
	mv $1 "${1}.backup-`date '+%Y.%m.%d.%H%M.%S'`"
} 

# ------------------------------------------------------------
# abs_path : Expand a relative path (e.g. containing ., .., or ~) to a full,
# absolute path.
abs_path () {
	ruby -e "puts File.expand_path('$1')"
}

celsius () {
	units "tempF($1)" tempC
}

fahrenheit () {
	units "tempC($1)" tempF
}

spell () {
	echo $* | ispell -o -B -S
}

textbytes () {
	objdump -T $1 | grep -E '^ +[0-9a-e]+:' | cut -d ':' -f 2 | \
	sed -r -e 's/^[[:space:]]//' -e 's/[[:space:]]{2}.*/ /' | tr -d '\n' 
}

humanize () {
	 ruby -r humanize -e "puts ${1}.humanize"
}

weather () {
	url='https://www.wunderground.com/cgi-bin/findweather/getForecast?query='
	wget -O - --quiet "${url}$1" | grep 'og:title' | cut -d '|' -f 2 | sed -e 's/&deg;//'
 }

# requires: wordnet wordnet-base wordnet-dev wordnet-grind wordnet-sense-index 
wordlookup () {
	wn $1 -over -synsn -synsv -synsa -synsr -antsn -antsv -antsa -antsr -grepn -grepv -grepa -grepr
}

pagetitle () {
	 wget --quiet -O - "$1" | sed -n -e 's!.*<title>\(.*\)</title>.*!\1!p'
}

# requires: gdb. default syscall is exit(0)
manhandle () {
	if [ $# -lt 1 ]
	then
		echo "Usage: manhandle PID [FUNCALL]"
		echo "   e.g. manhandle 123456 'fflush(0)'"
		return 0
	fi
	cmd="exit(0)"
	[ $# -gt 1 ] && cmd=$2
	gdb -p $1 -batch -ex "call $cmd"
}

geminfo () {
	gem specification $1 | grep summary
}

ls_rdata () {
	echo "print( load( \"$1\" ) )" | R -q --vanilla
}

git_is_master () {
	br=`git branch 2>/dev/null`
	if [ $? == 0 ] 
	then
		#[ `echo "$br" | grep '*' | cut -d ' ' -f 2` == 'master' ] && echo -e '\e[0;32mM\e[0m' || echo -e '\e[0;31m!\e[0m'
		[ `echo "$br" | grep '*' | cut -d ' ' -f 2` == 'master' ] && echo -e '\033[01;32mM\033[0m' || echo -e '\033[01;31m!\033[0m'
	else
		echo ""
	fi
}

display_stls () {
	find $1 -iname '*.stl' -exec fstl \{\} \;
}
