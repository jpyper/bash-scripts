#! /bin/bash
scriptversion="trunk"
scriptlastedit="20150825"
scriptauthor="John Pyper"
scriptsite="https://github.com/jpyper/bash-scripts"


#############
### ABOUT ###
#############
# This simple script compresses individual files with the same extension. It
# is useful for compressing emulator ROMs or PDFs.
#
# I was inspired to write this script based on a utility I used for Windows(tm)
# quite some time ago called ZipOne. It was/is a command line utility that was
# designed to do the same thing this script does.


####################
### REQUIREMENTS ###
####################
# ls,bc,zip
# OPTIONAL:
# (work in progress, not in listed order) gzip,p7zip,xz,rar,lzma,arj,...etc


###############
### LICENSE ###
###############
# This script is licensed under the MIT License.
# Details here: http://opensource.org/licenses/MIT


############################
### CONFIGURABLE OPTIONS ###
############################

# change this to where you want your compressed files to go.
outdir="."

#########################
### MAGIC INGREDIENTS ###
#########################

# start with a clean screen
clear

# set variables for $1 and $2 from the command line
filemask="$1"
comptype="$2"

# check command line options, display help or run section.
#if "$2" ; then
#	case "$2" in
#		zip*)		compexe="zip"
#				compopt="--quiet --move -9"
#				compext="zip"	;;
#
#		gzip*)		compexe="gzip"
#				compopt="--quiet --best"
#				compext="gz"	;;
#
#		*)		echo "[!] Unknown compression format."
#				exit 1		;;
#	esac
#else
#	echo "[*] Defaulting to ZIP compression format."
#	compexe="zip"
#	compopt="--quiet --move -9"
#	compext="zip"
#fi

# TEMPORARY
echo "[*] Defaulting to ZIP compression format."
compexe="zip"
compopt="--quiet --move -9"
compext="zip"


# Check if [outdir] exists, else make it.
if [ ! -d "${outdir}" ]; then
	echo "[!] Can't find OUTPUT directory: $outdir"
	echo "[!] Making directory."

	mkdir -p "${outdir}"
	if [ ${?} -gt 0 ]; then
		echo "[!] There was a problem creating the directory."
		echo "[!] Make sure you have write permissions to the directory specified."
		echo
		exit 1
	fi
fi


# display script header
echo
echo "+-----------------------------------------------"
echo "| Individual File Compressor"
echo "| version: ${scriptversion} (${scriptlastedit})"
echo "| by: ${scriptauthor}"
echo "| web: ${scriptsite}"
echo




# get number of files. initialize counters.
filetotal=$(find . -name "*.${filemask}" | wc -l)
filetotalorigsizeb="0"
filetotalorigsizeh="0"
filetotalcompsizeb="0"
filetotalcompsizeh="0"

# conversion process...
echo "+--------------------+"
echo "| Compressing files. |"
echo "| Please wait...     |"
echo "+--------------------+"
echo " * Compression: ${compext}"
echo " *   File Ext: .${filemask}"
echo

for a in *."${filemask}"
do
	# current file being worked with
	fileorigname="${a}"
	echo "FILE: ${a}"

	# get byte and human readable original file size
	fileorigsizeb=$(ls -l "${a}" | cut -d " " -f 5)
	fileorigsizeh="$(echo "scale=3; x=${fileorigsizeb} / 1048576; if(x<1) print 0; x" | bc) MB"
	echo "ORIG: ${fileorigsizeb} (${fileorigsizeh})"

	# compression command
	${compexe} ${compopt} "${a}.${compext}" "${a}"

	# get byte and human readable compressed file size
	filecompsizeb=$(ls -l "${fileorigname}.${compext}" | cut -d " " -f 5)
	filecompsizeh="$(echo "scale=3; x=${filecompsizeb} / 1048576; if(x<1) print 0; x" | bc) MB"
	echo "COMP: ${filecompsizeb} (${filecompsizeh})"
#	echo "FILE SIZE: ${fileorigsizeb} (${fileorigsizeh}) --> ${filecompsizeb} (${filecompsizeh})"

	# add file size in bytes to variable
	filetotalorigsizeb=$((${filetotalorigsizeb} + ${fileorigsizeb}))
	filetotalcompsizeb=$((${filetotalcompsizeb} + ${filecompsizeb}))

	echo
done

echo; echo; echo

# display some stats before script ends
echo "Files Processed:         ${filetotal}"
echo "Compression Method:      ${compext}"
echo "Original File Space:     ${filetotalorigsizeb} ($(echo "scale=3; x=${filetotalorigsizeb} / 1048576; if(x<1) print 0; x" | bc) MB)"
echo "Compressed File Space:   ${filetotalcompsizeb} ($(echo "scale=3; x=${filetotalcompsizeb} / 1048576; if(x<1) print 0; x" | bc) MB)"

echo
