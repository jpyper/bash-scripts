#!/usr/bin/env bash

#################################################
# run wine with 32-bit prefix on 64-bit systems #
#################################################

# set to absolute location where 32-bit WINE should run from
wine32dir="/home/${USER}/.wine32"


#---------------------------------------------------------------------------#

# check for WINE installation
if [ ! -f $(type -P wine) ] || [ ! -f $(type -P wine32) ]; then
	echo "WINE doesn't seem to be installed. Please install it before"
	echo "using this script."
	echo
	exit
fi

# check for WINE binary
if [ -f $(type -P wine) ]; then
	wine32bin=$(type -P wine)
elif [ -f $(type -P wine32) ]; then
	wine32bin=$(type -P wine32)
fi

# if 32-bit WINE prefix directory doesn't exist, create it
if [ ! -d "${wine32dir}" ]; then
	mkdir -p "${wine32dir}"
fi

# run WINE in the 32-bit prefix directory
env WINEPREFIX="${wine32dir}" WINEARCH="win32" ${wine32bin} "$@"
