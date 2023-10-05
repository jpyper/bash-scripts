#!/usr/bin/env sh


if test "${1}" = "";
then
	# show list of available cpu governors
	echo "Showing available governors for CPU0:"
	cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
	echo

	# show current cpu0 governor setting
	echo "CPU0 is currently set to:"
	cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo

	# show basic usage info
	echo "Usage: $(basename "$0") <one of the above cpu governors>"
	echo
else
	echo "You will more than likely be asked for your super user password to continue."
	echo "Setting ${1} on all CPU cores/threads:"
	echo
	echo "${1}" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
	echo
fi
