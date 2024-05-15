#!/usr/bin/env sh

## setcpugov.sh:
## This simple little script allows you to change the CPU governor, as long as
## the ability has been configured in the kernel and/or your motherboard's
## BIOS/(U)EFI Setup Utility.

## I have tried to keep this script as POSIX shell as possible, and it cleanly
## passes the ShellCheck utility's stringent checks.

## shellcheck -Cauto -s sh -o all ./setcpugov.sh

## [REQUIREMENTS]
## linux kernel			-> "linux" on most systems for the distro's stock kernel
## cat				-> coreutils
## echo				-> coreutils
## sudo				-> sudo
## tee				-> coreutils
## test				-> coreutils 


## check to see if necessary governor controls exist to continue running
if test ! -e "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors"; then
	echo "[E]: Changing governors is not supported at this time."
	echo
	echo "     This could be due to settings in the running kernel, or"
	echo "     settings in the BIOS/(U)EFI Setup Utility."
	echo
	exit
fi


if test "${1}" = "";
then
	## show current cpu0 governor setting
	echo "[I]: CPU0 is currently set to:"
	cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo

	## show list of available cpu governors
	echo "[I]: Showing available governors for CPU0:"
	cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
	echo

	## show basic usage info
	echo "Usage: $(basename "$0") <one of the above cpu governors>"
	echo
else
	echo "You will more than likely be asked for your super user password to continue."
	echo
	echo "Setting ${1} on all CPU cores/threads:"
	echo
	echo "${1}" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	echo
fi
