#!/usr/bin/env bash

# ripdvd.sh -
# This script is an attempt to make it easier for users to make backups
# of their DVD discs to store on their systems for convenient
# usage so that the original discs can stay in their protective cases to
# prevent damage.

# WARNING
# This script was not created for any type of illegal activities. The script
# author is in no way responsible and will not be held liable for activities
# the user does with this script.

# LEGAL
# In some countries, it is NOT legal to create copies of optical media,
# even for backup purposes. Also, in some countries, using tools/libraries to
# defeat copy protection on optical media to create backups is NOT legal.
#
# Use this script and dependency tools at your own risk.

# DEPENDENCIES
# This script was created on Ubuntu 16.04, and the following package are
# required for smooth operation:
#
# coreutils    (cut, mkdir, rm, ls)
# grep         (grep)
# libdvdread4  (library used by dvdbackup to read DVD media)
# libdvd-pkg   (downloads libdvdcss source, compiles it locally, and installs to your system)
# dvdbackup    (the workhorse behind this script)
# genisoimage  (the prettifier)

# NOTES
# This script uses BASH's "type -P" command to find needed dependencies in
# the system path. It is far more accurate and faster than using "which" to
# find things. As long as BASH is installed, there shouldn't be any problems.





#############################
# USER CONFIGURABLE OPTIONS #
#############################

# r_dvddrive: dvd drive identifier - /dev/sr0 /dev/cdrom /dev/dvd - pick one
r_dvddrive="/dev/sr0"

# r_workdir: location for temporary work files - needs about 18GB per disc
r_workdir="/tmp/${USER}-ripdvd"

# r_isosavedir: location to save the final .iso file - no trailing slash
r_isosavedir="${PWD}"

# r_grep: location of grep - from grep package - should be base installed
r_grep="$(type -P grep)"

# r_cut: location of cut - from coreutils - should be base installed
r_cut="$(type -P cut)"

# r_mkdir: location of kmdir - from coreutils - should be base installed
r_mkdir="$(type -P mkdir)"

# r_rm: location of rm - from coreutils - should be base installed
r_rm="$(type -P rm)"

# r_ls: location of ls - from coreutils - should be base installed
r_ls="$(type -P ls)"

# r_eject: location of eject - from eject package - should be base installed
r_eject="$(type -P eject)"

# r_dvdbackup: location of dvdbackup - from dvdbackup - used to backup DVD to hard drive
r_dvdbackup="$(type -P dvdbackup)"

# r_isoinfo: location of isoinfo - from genisoimage package
r_isoinfo="$(type -P isoinfo)"

# r_genisoimage: location of genisoimage - from genisoimage - used to create DVD ISO image
r_genisoimage="$(type -P genisoimage)"

###[ DO NOT CHANGE r_dvdvolname ]###
# r_dvdvolname: get volume name of dvd in drive - this will be used later
r_dvdvolname="$(${r_isoinfo} -d -i ${r_dvddrive} | ${r_grep} -i "volume id:" | ${r_cut} -d " " -f3)"

# r_dvdbackup_opts: command line options for dvdbackup. "man dvdbackup" for details.
#r_dvdbackup_opts="--mirror --progress --verbose --error b --input ${r_dvddrive} --output ${r_workdir}"
r_dvdbackup_opts="--mirror --progress --error b --input ${r_dvddrive} --output ${r_workdir}"

# r_genisoimage_opts: command line options for genisoimage. "man genisoimage" for details.
r_genisoimage_opts="-dvd-video -udf -V "${r_dvdvolname}" -o "${r_isosavedir}/${r_dvdvolname}.iso""




###################################
###################################
### WHOOSH! MAGIC HAPPENS BELOW ###
###################################
###################################





################################################
###[ PHASE 0: CHECK FOR SAME NAMED ISO FILE ]###
################################################

# display dvd drive and disc volume name
echo
echo "SOURCE DRIVE: ${r_dvddrive}"
echo " VOLUME NAME: ${r_dvdvolname}"
echo

# check for same named .iso file in r_isosavedir and halt if exists
if [ -f "${r_isosavedir}/${r_dvdvolname}.iso" ]; then
	echo
	echo "WARNING: Sometimes, DVD authors are lazy and don't change the"
	echo "         volume name on multiple discs in a series. This leads"
	echo "         to more than one disc with the same name. An obvious"
	echo "         solution would be to just add an incrimenting number"
	echo "         to the r_dvdvolname part of the file name to keep the"
	echo "         process progressing. Unfortunately, this script is not"
	echo "         yet equipped to handle such tasks."
	echo
	echo "         File on disk: ${r_isosavedir}/${r_dvdvolname}.iso"
	echo
	echo "         Please rename or move the file shown above to another"
	echo "         location on your drive."
	echo
	echo " THIS SCRIPT CAN NOT CONTINUE."
	echo
	exit
fi




################################################
###[ PHASE 1: MAKE TEMPORARY WORK DIRECTORY ]###
################################################

# check for temporary work directory. if it exists, halt script.
# if not, create directory and continue.
if [ -d "${r_workdir}" ]; then
	echo "WARNING: Directory exists at ${r_workdir}."
	echo "         Remove the directory or change the r_workdir variable at the top"
	echo "         of this script to another location."
	echo
	echo " THIS SCRIPT CAN NOT CONTINUE."
	echo
	exit
else
	echo "INFO:    Attempting to create temporary work directory..."
	echo
	${r_mkdir} -v -p "${r_workdir}"
	if [ "${?}" -eq "0" ]; then
		echo "INFO:    Directory successfully created."
		echo
	else
		echo "WARNING: Something didn't go as planned while creating the directory."
		echo "         Take a look at any info above and try to rectify the issue."
		echo
		echo "         r_workdir is: ${r_workdir}"
		echo "         Check this directory to see if there are any files in it,"
		echo "         or delete the directory to start fresh."
		echo
		echo " THIS SCRIPT CAN NOT CONTINUE."
		echo
		exit
	fi
fi





#####################################################
###[ PHASE 2: BACKUP DVD STRUCTURE TO HARD DRIVE ]###
#####################################################

if [ ! -f "${r_dvdbackup}" ]; then
	echo "WARNING: dvdbackup program not found."
	echo "         Please make sure the r_dvdbackup variable at the top"
	echo "         of this script is pointing to the right location,"
	echo "         or install the \"dvdbackup\" package."
	echo
	echo " THIS SCRIPT CAN NOT CONTINUE."
	echo
	exit
else
	echo
	echo "INFO:    Starting DVD backup process..."
	echo
	${r_dvdbackup} ${r_dvdbackup_opts}
	if [ "${?}" -eq "0" ]; then
		echo
		echo "INFO:    DVDBACKUP was successful."
		echo
	else
		echo "WARNING: Something didn't go as planned while copying the"
		echo "         DVD contents to the hard drive. Check for any"
		echo "         contents in ${r_workdir} that you may want to keep"
		echo "         and try again."
		echo
		echo " THIS SCRIPT CAN NOT CONTINUE."
		echo
		exit
	fi
fi



# eject disc from drive so it can be safely stored
${r_eject} ${r_dvddrive}


######################################
###[ PHASE 3: CREATE DVD ISO FILE ]###
######################################

if [ ! -f "${r_genisoimage}" ]; then
	echo "WARNING: genisoimage program not found."
	echo "         Please make sure the r_genisoimage variable at the top"
	echo "         of this script is pointing to the right location,"
	echo "         or install the \"genisoimage\" package."
	echo
	echo " THIS SCRIPT CAN NOT CONTINUE."
	echo
	exit
else
	echo
	echo "INFO:    Getting DVD temporary directory..."
	echo
	r_dvdstructure=$(${r_ls} -1 ${r_workdir/})
	echo
	echo "INFO:    Looks like the DVD structure is located at:"
	echo "         ${r_workdir}/${r_dvdstructure}"
	echo
	echo "INFO:    Beginning DVD ISO file construction..."
	echo
	${r_genisoimage} ${r_genisoimage_opts} "${r_workdir}/${r_dvdstructure}"
	if [ "${?}" -eq "0" ]; then
		echo
		echo "INFO:    Looks like everything went well."
		echo
	else
		echo
		echo "WARNING: Something didn't go as planned while copying the"
		echo "         DVD contents to the hard drive. Check for any"
		echo "         contents in ${r_workdir} that you may want to keep"
		echo "         and try again."
		echo
		echo " THIS SCRIPT CAN NOT CONTINUE."
		echo
		exit
	fi
fi





########################################################
###[ PHASE 4: CLEAN UP THE TEMPORARY WORK DIRECTORY ]###
########################################################

# make sure to quote "${r_workdir}" when recursively
# deleting the files in the work ddirectory. if you don't,
# it could lead to some serious problems if there are
# directories with spaces in them.

echo "INFO:    Since this is a respective and nice little script,"
echo "         it will now clean up after itself to free up some"
echo "         space on your drive."
echo

${r_rm} -rv "${r_workdir}"

echo
echo "INFO:    You should have a shiny new DVD ISO located at:"
echo "         ${r_isosavedir}/${r_dvdvolname}.iso"
echo
echo "         Check the file with a player like VLC to make sure"
echo "         it works. If all went as planned, your DVD ISO image"
echo "         should play as if the player is playing directly from"
echo "         the DVD disc itself."
echo

