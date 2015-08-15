#!/bin/sh
scriptversion="trunk"
scriptlastedit="20150815"
scriptauthor="John Pyper"
scriptsite="https://github.com/jpyper/bash-scripts"


#############
### ABOUT ###
#############
# This is a simple script that downloads webaom.jnlp from static.anidb.net and runs the
# client locally. Since the script always downloads the webaom.jnlp file each time it
# is run, it will make sure you are running the latest version of the java client (even
# though it hasn't been updated in ages).
#
# Information about the AniDB WebAOM (Anime-O-Matic) can be found at:
# http://wiki.anidb.info/w/WebAOM


####################
### REQUIREMENTS ###
####################
# openjdk-7-jre, icedtea-netx, wget


###############
### LICENSE ###
###############
# This script is licensed under the Fair License.
# Details here: http://opensource.org/licenses/Fair


############################
### CONFIGURABLE OPTIONS ###
############################

# workdir: a temporary directory where files can be downloaded to and work from.
workdir="/tmp/${USER}/webaom"

# javabin: full path location of 'java' binary.
javabin="$(which java)"

# javawsbin: full path location of 'javaws' binary.
javawsbin="$(which javaws)"

# wgetbin: full path location of 'wget' binary.
wgetbin="$(which wget)"


#########################
### MAGIC INGREDIENTS ###
#########################

function waom_test_util_requirements() {
# test for external requirements to do the job

        echo "+---------------------------------+"
        echo "| Checking for external utilities |"
        echo "+---------------------------------+"
        echo

	# check for java installation
	if [ ! -f ${javabin} ]; then
                echo ":-( This script can not locate the 'java' binary."
                echo "    Check the 'javabin' variable at the top of this script. Make sure it is pointing to the 'java' binary."
                echo "    Install the 'openjdk-8-jre' package provided by your distribution, or"
                echo "    obtain source from http://openjdk.java.net/ and compile a binary to use."
                echo
		exit 1
	else
		echo ":-) [X] openjdk-?-jre"
	fi


	# check for javaws installation
	if [ ! -f ${javawsbin} ]; then
                echo ":-( This script can not locate the 'javaws' binary."
                echo "    Check the 'javawsbin' variable at the top of this script. Make sure it is pointing to the 'javaws' binary."
                echo "    Install the 'icedtea-netx' package provided by your distribution, or"
                echo "    obtain source from http://icedtea.classpath.org/ and compile a binary to use."
                echo
		exit 1
	else
		echo ":-) [X] icedtea-netx"
	fi


	# check for wget installation
	if [ ! -f ${wgetbin} ]; then
                echo ":-( This script can not locate the 'wget' binary."
                echo "    Check the 'wgetbin' variable at the top of this script. Make sure it is pointing to the 'wget' binary."
                echo "    Install the 'wget' package provided by your distribution, or"
                echo "    obtain source from https://www.gnu.org/software/wget/ and compile a binary to use."
                echo
		exit 1
	else
		echo ":-) [X] wget"
		echo
	fi
}


function waom_check_output_directory() {
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


function waom_download_run_webaom() {
# try to download java webstart file and run it

	echo "+--------------------------------------------------------+"
	echo "| Attempting to download file from AniDB.net's server... |"
	echo "+--------------------------------------------------------+"
	echo

	# download the webaom.jnlp file from anidb
	${wgetbin} -nv http://static.anidb.net/client/webaom.jnlp -O "${workdir}/webaom.jnlp"
	if [ ${?} -gt 0 ]; then
		echo ":-( Download FAILED."
		echo
		echo "    Some reasons why the download may have failed:"
		echo "    	1) The server at AniDB.net might be over capacity, preventing download."
		echo "     		Please try running this script again in a few minutes to see if the"
		echo "    		server traffic has subsided."
		echo "    	2) You might not have write permissions to ${workdir}"
		echo "    		Make sure the 'workdir' variable at the top of this script points to"
		echo "   		a directory that is writable by the user running this script."
		echo
		exit 1
	else
		echo
		echo ":-) File successfully downloaded."
		echo "    Running AniDB.net WebAOM client."
		echo
		${javawsbin} "${workdir}/webaom.jnlp"
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
echo "+--------------------------------------------------"
echo "| AniDB.net Java WebAOM (Anime-O-Matic) Downloader"
echo "| version: ${scriptversion} (${scriptlastedit})"
echo "| by: ${scriptauthor}"
echo "| web: ${scriptsite}"
echo

# step 1: check for required possibly not installed by default binaries to operate script.
waom_test_util_requirements

# step 2: test for output directory. create if needed.
waom_check_output_directory

# step 3: try to download .jnlp file and run it
waom_download_run_webaom
