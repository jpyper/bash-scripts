#!/usr/bin/env bash

# log file to get dnsmasq log info from
logfile="/var/log/dnsmasq.log"
#logfile="/var/log/messages"






# check for required command line option
case "${1}" in
	query | "-q")
		sudo tail -F ${logfile} | sed 's/.*]: //' | grep "query\["
		;;
	reply | "-r")
		sudo tail -F ${logfile} | sed 's/.*]: //' | grep "reply "
		;;
	cached | "-c")
		sudo tail -F ${logfile} | sed 's/.*]: //' | grep "cached "
		;;
	*)
		# show usage
		echo "dnslog.sh requires one of the following options to run:"
		echo "** Your/root password is required to access dnsmask.log file only. **"
		echo
		echo "dnslog.sh -q		- shows \"query\" lines"
		echo "dnslog.sh -r		- shows \"reply\" lines"
		echo "dnslog.sh -c		- shows \"cached\" lines"
		echo
		echo "Running each command line option in a terminal multiplexor like tmux"
		echo "makes DNS server monitoring more useful."
		echo
		echo "tmux screen split example:"
		echo "+-----------------------------------------------------+"
		echo "| user@host ~: dnslog.sh -q                           |"
		echo "|                                                     |"
		echo "|                                                     |"
		echo "+-----------------------------------------------------+"
		echo "| user@host ~: dnslog.sh -r                           |"
		echo "|                                                     |"
		echo "|                                                     |"
		echo "+-----------------------------------------------------+"
		echo "| user@host ~: dnslog.sh -c                           |"
		echo "|                                                     |"
		echo "|                                                     |"
		echo "+-----------------------------------------------------+"
		echo
esac
