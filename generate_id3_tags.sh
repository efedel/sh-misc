#!/bin/bash

# GENRES
UNKNOWN='Unknown'
ALT='alt'
BLUES='blues'
CLASSICAL='classical'
COUNTRY='Cuntrie'
JAZZ='jazz'
LOUNGE='l0ung3'
MISC='misc'
PSYCH='psyk0bil3'
PUNK='pVnk'
ROCK='r0k'
SOUL='s0ul'
SDTRK='soundtracks'
TECHNO='t3k'

get_genre () {
	ID3_GENRE="$UNKNOWN"
	if [ "$1" = "$ALT" ] ; then
		ID3_GENRE="Alternative"
	elif [ "$1" = "$BLUES" ] ; then
		ID3_GENRE="Blues"
	elif [ "$1" = "$CLASSICAL" ] ; then
		ID3_GENRE="Classical"
	elif [ "$1" = "$COUNTRY" ] ; then
		ID3_GENRE="Country"
	elif [ "$1" = "$JAZZ" ] ; then
		ID3_GENRE="Jazz"
	elif [ "$1" = "$LOUNGE" ] ; then
		ID3_GENRE="Lounge"
	elif [ "$1" = "$MISC" ] ; then
		ID3_GENRE="Other"
	elif [ "$1" = "$PSYCHO" ] ; then
		ID3_GENRE="Psychobilly"
	elif [ "$1" = "$PUNK" ] ; then
		ID3_GENRE="Punk"
	elif [ "$1" = "$ROCK" ] ; then
		ID3_GENRE="Rock"
	elif [ "$1" = "$SOUL" ] ; then
		ID3_GENRE="Soul"
	elif [ "$1" = "$SDTRK" ] ; then
		ID3_GENRE="Soundtrack"
	elif [ "$1" = "$TECHNO" ] ; then
		ID3_GENRE="Techno"
	fi
}

set_id3_tags () {
	GENRE="$1"
	ARTIST="$2"
	ALBUM="$3"
	NAME="$4"
	TRACK="$5"

	echo $GENRE:$ARTIST:$ALBUM:$NAME:$TRACK
}

capitalize () {
	CAPITALIZED=""
	for n in ${1##*/} ; do
		N=${n^}
		[ -z "$CAPITALIZED" ] && CAPITALIZED="$N" || \
			CAPITALIZED="$CAPITALIZED $N"
	done
}

tag_file () {
	MP3="$1"
	ALBUM="${MP3%/*}"
	ARTIST="${ALBUM%/*}"
	GENRE="${ARTIST%/*}"

	# ignore directories
	if [ -d "$MP3" ]; then
		echo "ERROR 1 IN $MP3"
		return 1
	fi

	# handle cases with no album
	get_genre "${ARTIST##*/}"
	if  [ "$ID3_GENRE" != "$UNKNOWN" ]; then
		GENRE="$ARTIST"
		ARTIST="$ALBUM"
		ALBUM=""
	fi

	# handle cases with album subdirs
	get_genre "${GENRE##*/}"
	if [ "$ID3_GENRE" = "$UNKNOWN" ] ; then
		ALBUM="$ARTIST"
		ARTIST="$GENRE"
		GENRE="${GENRE%/*}"
		get_genre "${GENRE##*/}"
		if [ "$ID3_GENRE" = "$UNKNOWN" ] ; then
			echo "ERROR 2 IN $MP3"
			return 2
		fi
	fi
	
	RAW_NAME="${MP3##*/}"
	RAW_NAME="${RAW_NAME%.*}"
	capitalize "${RAW_NAME//_/ }"
	MP3_NAME="$CAPITALIZED"

	TRACK=""
	if [[ $MP3_NAME == [0-9][0-9]* ]] ; then
		TRACK=${MP3_NAME%%[-_ ]*}
		MP3_NAME=${MP3_NAME##[0-9][0-9][-_ ]}
	fi

	capitalize "${ARTIST##*/}"
	MP3_ARTIST="$CAPITALIZED"

	capitalize "${ALBUM##*/}"
	MP3_ALBUM="$CAPITALIZED"

	set_id3_tags "$ID3_GENRE" "$MP3_ARTIST" "$MP3_ALBUM" "$MP3_NAME" \
		     "$TRACK"
}

build_id3_tags () {
	find $1 -type f | while read f; do tag_file "$f"; done
}

until [ -z "$1" ] ; do
	build_id3_tags $1
	shift
done
