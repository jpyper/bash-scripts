#!/bin/bash
scriptversion="trunk"
scriptlastedit="20150825"
scriptauthor="John Pyper"
scriptsite="https://github.com/jpyper/bash-scripts"


#############
### ABOUT ###
#############
# This is a simple script that uses 'youtube-dl' to download almost any
# video from YouTube or other sites supported by the 'youtube-dl' utility.
# It will not allow you to download videos that are private or cost money,
# like video rentals. This script was designed to allow you to backup or
# recover your local lost videos. Do not abuse the system. They're watching.


####################
### REQUIREMENTS ###
####################
# youtube-dl, find, wc


###############
### LICENSE ###
###############
# This script is licensed under the MIT License.
# Details here: http://opensource.org/licenses/MIT


############################
### CONFIGURABLE OPTIONS ###
############################

# outdir: full path where to save the file
outdir="${HOME}/Videos/ytdl"

# ytdlbin: full path location of 'youtube-dl' binary
ytdlbin=$(which youtube-dl)

# ytdlopts: common options for use with 'youtube-dl'. See 'youtube-dl --help' for details.
ytdlopts="--ignore-config --ignore-errors --retries 5 --no-overwrites --continue --console-title --no-check-certificate --prefer-insecure --format mp4/flv --all-subs --embed-subs --add-metadata --prefer-avconv"

# ytdloutfile: Output Filename Template -- See youtube-dl --help, Filesystem Options: -o command
ytdloutfile="%(title)s [%(height)sp][%(extractor)s][%(id)s].%(ext)s"

# ytdlua: Internet Explorer 12 Edge on Windows 10 x32
ytdlua="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36 Edge/12.0"
# ytdlua: Google Chrome 37 on Windows 8.1 x64
#ytdlua="Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36"


#########################
### MAGIC INGREDIENTS ###
#########################

# not sure what to call this, but it makes the functions accept global variables
arg1="$1"

ytdl_check_requirements() {
# check for required extrnal utilities and check command line options.

	# check command line parameters. no sense in parsing the rest if there's nothing here.
	if [ ! "${arg1}" ]; then
		echo "Nothing was specified on the command line for action."
		echo
		echo "[OPTIONS]"
		echo
		echo "Download a file:"
		echo "    $0 someURL"
		echo
		echo "Tip: If a URL contains an ampersand (\"&\") in it, make sure to quote the URL like so..."
		echo
		echo "    $0 \"http://somesite/watch?v=32f3wqf&pl=efvwqerf\""
		echo
		exit 1
	fi


	# check for output directory. if it doesn't exist, create it.
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


	#check for 'youtube-dl' binary
        echo "+-------------------------+"
        echo "| Checking for youtube-dl |"
        echo "+-------------------------+"
        echo
	if [ ! -f "${ytdlbin}" ]; then
                echo ":-( This script can not locate the 'youtube-dl' binary."
                echo "    Check the 'ytdlbin' variable at the top of this script. Make sure it is pointing to the 'youtube-dl' binary."
                echo "    Install the 'youtube-dl' package provided by your distribution, or"
                echo "    obtain source from https://rg3.github.io/youtube-dl/ and compile a binary to use."
                echo
                exit 1;
	else
		echo ":-) [X] youtube-dl"
		echo
        fi
}


ytdl_get_remote_file() {
# attempt to download remote file.

        echo "+------------------------------------------------+"
        echo "| Trying to download remote file. Please wait... |"
        echo "+------------------------------------------------+"
        echo
	${ytdlbin} 	${ytdlopts} \
			--user-agent "${ytdlua}" \
			--output "${outdir}/${ytdloutfile}" \
			"${arg1}"
	echo
}

ytdl_remove_srt_files() {
# check for and remove any .srt subtitle files.

	srt_files=$(find "${outdir}" -name "*.[Ss][Rt][Tt]" | wc -l)
	if [ "${srt_files}" -gt "0" ]; then
		echo "[filesys] Removing -${srt_files}- temporary SRT subtitle files."
		rm "${outdir}/*.srt"
		echo
	fi

}


########################
### [ MAGICAL SOUP ] ###
########################

# let's start with a blank screen
clear

# display script header
echo
echo "+-----------------------------------------------"
echo "| YouTube (and others) Single File Downloader"
echo "| version: ${scriptversion} (${scriptlastedit})"
echo "| by: ${scriptauthor}"
echo "| web: ${scriptsite}"
echo


# step 1: check for command line options and required utilities
ytdl_check_requirements

# step 2: download remote file
ytdl_get_remote_file

# step 3: remove any subtitle .srt files if found
ytdl_remove_srt_files
