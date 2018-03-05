#!/usr/bin/env bash

# my7z:
# Simple script to make .7z archives much easier.



### [ USER CHANGEABLE VARIABLES ] ###
# my7zbin: location of the 7z binary
my7zbin="$(type -P 7z)"
# my7zopt: options for 7z
# details file:///usr/share/doc/p7zip/DOC/MANUAL/cmdline/commands/add.htm
# -mmt $() counts number of "processor" sections in /proc/cpuinfo for threading
#my7zopt="-mx=9 -myx=9 -ms=on -mf=on -mhc=on -mmt=$(cat /proc/cpuinfo | grep processor | wc -l) -m0=LZMA2:a=1:c=64m:d=1024m:mf=bt4:fb=276:mc=999999999 -r"
my7zopt="-mx=9 -myx=9 -ms=on -mf=on -mhc=on -mmt=off -m0=LZMA2:a=1:d=1024m:mf=bt4:fb=276:mc=999999999 -r"


### [ GLOBAL VARIABLES - DON'T CHANGE] ###
myarchive="${1}"
myinput="${2}"


### [ FUNCTIONS ] ###
function show_usage() {
	echo "USAGE:"
	echo "my7z \"Archive Name.7z\" \"Original File.ext\"  - archive a single file"
	echo "my7z \"Archive Name.7z\" .                    - archive a directory"
	echo
	exit 1
}

function get_working() {
	${my7zbin} a ${my7zopt} "${1}" "${2}"
}


### [ CHECK COMMAND LINE OPTIONS ] ###
if [ ! "${1}" ]; then
	echo
	echo "ERROR:"
	echo "No ARCHIVE filename detected."
	echo
	show_usage
fi

if [ ! "${2}" ]; then
	echo
	echo "ERROR:"
	echo "No INPUT filename/directory detected."
	echo
	show_usage
fi


### [ LET THE MAGIC BEGIN ] ###
echo
echo "INFO: Attempting to squeeze the bits out of the input file(s)/directory"
get_working "${myarchive}" "${myinput}"
echo
echo


### [ SHOW THE YUMMY BAKED GOODS ] ###
if [ -f "${myarchive}" ]; then
	echo "INFO: Your new archive..."
	ls -lh "${myarchive}"
	echo
else
	echo "ERROR:"
	echo "There was an error from 7z. Read above for details."
	echo
fi
