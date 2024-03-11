#!/usr/bin/env bash

# if not set, using the basename($0, '.php');
file=''

#
real="$(realpath "$0")"
dir="$(dirname "$real")"
php="`which php 2>/dev/null`"

if [[ -z "$php" ]]; then
	echo " >> No \`php\` interpreter found!" >&2
	exit 1
elif [[ -z "$file" ]]; then
	file="$(basename "$real" .sh).php"
fi

#
eval "${php} ${dir}/${file} \"$@\""

