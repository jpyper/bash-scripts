#! /bin/bash
scriptversion="trunk"
scriptlastedit="20150816"
scriptauthor="John Pyper"
scriptsite="https://github.com/jpyper/bash-scripts"


#############
### ABOUT ###
#############
# This is a simple script that takes input FLAC file(s) in a directory and creates
# output MP3 file(s). Commonly used to convert high quality lossless FLAC audio to
# high quality lossy MP3 audio for portable music players and devices that do not
# support the FLAC file format.
#
# Tip: Place this script in your '$USER/bin' directory, then 'chmod +x flac2mp3.sh'.
#      As long as '$USER/bin' is in your '$PATH', the script can be run anywhere
#      on the system.


####################
### REQUIREMENTS ###
####################
# flac, metaflac, lame, sed, grep, cut, which, find, mkdir, wc


###############
### LICENSE ###
###############
# This script is licensed under the Fair License.
# Details here: http://opensource.org/licenses/Fair


############################
### CONFIGURABLE OPTIONS ###
############################

# outdir: change this to where you want your converted files to go. default makes a
#         directory called mp3 in the directory where the script is run from.
outdir="${PWD}/mp3"

# flacbin: full path location of 'flac' binary
flacbin=$(which flac)

# flacopts: decode file, include errors if present, to pipe. 'man flac' for details.
flacopts="--totally-silent --decode --decode-through-errors --stdout"

# metaflacbin: full path location of 'metaflac' binary
metaflacbin=$(which metaflac)

# lamebin: full path location of 'lame' binary
lamebin=$(which lame)

# lameopts: Joint stereo, highest quality variable bitrate stream.
#           Please read the manpage 'man lame' or 'lame --longhelp' for option details.
lameopts="--quiet -m j -q 0 -V 0 --vbr-new -T -c -o -p -b 32 --noreplaygain --add-id3v2 --pad-id3v2 --ignore-tag-errors"


#########################
### MAGIC INGREDIENTS ###
#########################

f2m_check_script_requirements() {
	# make sure we have the required, possibly not installed by default, utilities to do the job.

	# check that flacbin points to a valid file
	if [ ! -f ${flacbin} ]; then
		echo ":-( This script can not locate the flac binary."
		echo "    Check the 'flacbin' variable at the top of this script. Make sure it is pointing to the flac binary."
		echo "    Install the 'flac' package provided by your distribution, or"
		echo "    obtain source from https://www.xiph.org/flac/ and compile a binary to use."
		echo
		exit 1;
	fi

	# check that metaflacbin points to a valid file
	if [ ! -f ${metaflacbin} ]; then
		echo ":-( This script can not locate the metaflac binary."
		echo "    Check the 'metaflacbin' variable at the top of this script. Make sure it is pointing to the metaflac binary."
		echo "    Install the 'flac' package provided by your distribution, or"
		echo "    obtain source from https://www.xiph.org/flac/ and compile a binary to use."
		echo
		exit 1;
	fi

	# check that lamebin points to a valid file
	if [ ! -f ${lamebin} ]; then
		echo ":-( This script can not locate the lame binary."
		echo "    Check the 'lamebin' variable at the top of this script. Make sure it is pointing to the lame binary."
		echo "    Install the 'lame' package provided by your distribution, or"
		echo "    obtain source from http://lame.sourceforge.net/ and compile a binary to use."
		echo
		exit 1;
	fi
}


f2m_check_output_directory() {
# check for output directory
	echo "+-------------------------------+"
	echo "| Checking for output directory |"
	echo "+-------------------------------+"
	echo
	if [ ! -d "${outdir}" ]; then
		echo ":-( Can't find output directory:"
		echo "      ${outdir}"
		echo ":-| Creating directory."
		mkdir -p "${outdir}"
		if [ ${?} -gt 0 ]; then
			echo ":-( There was a problem creating the directory."
			echo "    Make sure you have write permissions to the directory specified."
			echo
			exit 1
		fi
		echo ":-) Directory successfully created."
		echo
	else
		echo ":-) Found output directory:"
		echo "      ${outdir}"
		echo
	fi
}


f2m_test_directory_flac_files() {
	echo "+-------------------------------------------+"
	echo "| Testing source FLAC files. Please wait... |"
	echo "+-------------------------------------------+"
#	echo
	${flacbin} --test ./*.[Ff][Ll][Aa][Cc]
	if [ ${?} != 0 ]; then
		echo
		echo ":-( Testing of FLAC files encountered a problem. Please look over the results above."
		echo
		exit 2
	fi
	echo
}


f2m_flac_to_mp3_conversion() {
	echo "+----------------------------------------+"
	echo "| Converting FLAC to MP3. Please wait... |"
	echo "+----------------------------------------+"
	echo

	# get number of flac files in directory. initialize counter.
	filetotal=$(find . -name "*.[Ff][Ll][Aa][Cc]" | wc -l)
	filecount="0"

	for a in ./*.[Ff][Ll][Aa][Cc]; do

		# get flac file meta info
#		filebase="$(echo "$a" | sed s/.flac//g)"
		filebase="${a//.flac/}"
		fileartist="$(metaflac "${a}" --show-tag=ARTIST | sed s/.*=//g)"
		filetitle="$(metaflac "${a}" --show-tag=TITLE | sed s/.*=//g)"
		filetrack="$(metaflac "${a}" --show-tag=TRACKNUMBER | sed s/.*=//g)"
		filealbum="$(metaflac "${a}" --show-tag=ALBUM | sed s/.*=//g)"

		# print some artist and album info
		if [ ${filecount} -lt 1 ]; then
			echo "ARTIST: ${fileartist}"
			echo "ALBUM:  ${filealbum}"
			echo
		fi

		# increment file number +1 for each run through the loop
		filecount=$((filecount + 1))

		# show file number of total files being worked on and current file name minus extension
		echo "[${filecount}/${filetotal}] ${fileartist} -- ${filetitle}"

		# this is where the cooking, err, converting happens
		${flacbin} ${flacopts} "${filebase}.flac" | ${lamebin} ${lameopts} --ta "${fileartist}" --tt "${filetitle}" --tl "${filealbum}" --tn "${filetrack:-0}" - "${outdir}/${filebase}.mp3"

	done
	echo
}


f2m_show_outdir_contents() {
	echo "+--------------------------------------+"
	echo "| Here are your fresh new MP3 files... |"
	echo "+--------------------------------------+"
	echo
	ls -lh "${outdir}"
	echo
}





########################
### [ MAGICAL SOUP ] ###
########################

# let's start with a blank screen
clear

# display script header
echo
echo "+-----------------------------------------------"
echo "| FLAC to MP3 Converter"
echo "| version: ${scriptversion} (${scriptlastedit})"
echo "| by: ${scriptauthor}"
echo "| web: ${scriptsite}"
echo

# step 1: check for required possibly not installed by default binaries to operate script.
f2m_check_script_requirements

# step 2: test for output directory. create if needed.
f2m_check_output_directory

# step 3: test the integrity of flac file(s) in the directory. halt script operations if flac file errors are encountered.
f2m_test_directory_flac_files

# step 4: read flac file(s) to produce new mp3 file(s).
f2m_flac_to_mp3_conversion

# step 5: show directory list of newly created mp3 file(s).
f2m_show_outdir_contents
