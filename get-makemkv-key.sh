#!/bin/sh
scriptversion="trunk"
scriptlastedit="20200620"
scriptauthor="John Pyper"
scriptsite="https://github.com/jpyper/bash-scripts"


#################
### [ ABOUT ] ###
#################
# -=[ MAKEMKV BETA REGISTRATION KEY RETRIEVER ]=-
#
# Quick script to get the most current MakeMKV registration key while it is still in beta (forever?).
#
# MakeMKV seems to be in a forever free beta (but that could change at any time), I highly recommend
# purchasing a lifetime registration code for the reasonably valued cost of $50 USD.
# https://www.makemkv.com/buy/
#####################################################################################################


########################
### [ USER OPTIONS ] ###
########################
# url to forum post where makemkv key is posted, official from the developer.
# please don't change this setting. if the url does change, i will update the script and push a new version out.
keypage="https://www.makemkv.com/forum/viewtopic.php?f=5&t=1053"
# full path to place temporary keypage file
keypagetmp="/tmp/.keypage"
# where is the 'curl' binary
curlbin="curl"
# where is the 'grep' binary
grepbin="grep"
# where is the 'sed' binary
sedbin="sed"
# where is the 'rm' binary
rmbin="rm"
#####################################################################################################

#####################
### [ CHANGELOG ] ###
#####################
# 20200620:
#   - removed BASH 'type -P' callouts to find dependencies
#   ~ changed default USER OPTIONS for binaries to blindly point to their name
#   + added 'rm' as a dependency
#   + now using a temp file to locally cache the remote page and remove it when done ... seems to be a dirty necessity
#   + add check to make sure keypagetmp file downloaded
#   + add check for keypagetmp file and remove it when finished
#   + added a simple sub-shell call to test for each dependency binary version, just looking for a reply
#   = don't assume dependencies are installed in base (but they should be)
#   = according to "shellcheck -s sh get-makemkv-key.sh", this script does not contain any suggestions/errors/breaks
#   + that should make this script fully POSIX compliant
# 20200617:
#   ~ changed shebang at top of script from "/usr/bin/env bash" to "/bin/sh" for more compatibility
#   ~ changed double brackets to single brackets in if statements for POSIX compliance
#   + added a couple of double quotes around a few variables for POSIX compliance
#   + added ${keypage} to the ${makemkv_key_forum_post} because I forgot I had the actual url in there...oops
#   - removed BASH version check, since script no longer targets BASH for its shell
# 20200616:
#   - removed occurances of using 'which' to find commands
#   + use BASH's built-in 'type -P' to find commands faster
#   + add BASH version check to DEPENDENCIES CHECK section
#   + add MIT license
#   + add this CHANGELOG section
# 20200615:
#   + initial release
#####################################################################################################


###################
### [ LICENSE ] ###
###################
# This script is licensed under the MIT License.
# Details here: http://opensource.org/licenses/MIT
#####################################################################################################


##############################
### [ DEPENDENCIES CHECK ] ###
##############################

# check for 'curl' binary
curltest="$(${curlbin} --version)"
if [ "${curltest}" = "" ]; then
	echo "[E]: curl binary not found."
	echo "[E]: the 'curlbin' variable at the top of this script"
	echo "[E]: points to: ${curlbin}"
	echo
	echo "Check your package manager for 'curl' and install it, or"
	echo "set the proper path in the 'curlbin' variable."
	exit
fi

# check for 'grep' binary
greptest="$(${grepbin} --version)"
if [ "${greptest}" = "" ]; then
	echo "[E]: grep binary not found."
	echo "[E]: the 'grepbin' variable at the top of this script"
	echo "[E]: points to: ${grepbin}"
	echo
	echo "Check your package manager for 'grep' and install it, or"
	echo "set the proper path in the 'grepbin' variable."
	exit
fi

# check for 'sed' binary
sedtest="$(${sedbin} --version)"
if [ "${sedtest}" = "" ]; then
	echo "[E]: sed binary not found."
	echo "[E]: the 'sedbin' variable at the top of this script"
	echo "[E]: points to: ${sedbin}"
	echo
	echo "Check your package manager for 'sed' and install it, or"
	echo "set the proper path in the 'sedbin' variable."
	exit
fi

# check for 'rm' binary
rmtest="$(${rmbin} --version)"
if [ "${rmtest}" = "" ]; then
	echo "[E]: rm binary not found."
	echo "[E]: the 'rmbin' variable at the top of this script"
	echo "[E]: points to: ${rmbin}"
	echo
	echo "Check your package manager for 'coreutils' and install it, or"
	echo "set the proper path in the 'rmbin' variable."
	exit
fi

#####################################################################################################


#############################
### [ DO THE DIRTY WORK ] ###
#############################

# let's start with a blank screen
clear

# display script header
echo "+-----------------------------------------------"
echo "| MakeMKV Beta Registration Key Retriever"
echo "| version: ${scriptversion} (${scriptlastedit})"
echo "| by: ${scriptauthor}"
echo "| web: ${scriptsite}"
echo "+-----------------------------------------------"
echo
echo "MakeMKV is free while in beta, and has been for a VERY long time."
echo
echo "Info extracted from forum post: https://www.makemkv.com/forum/viewtopic.php?f=5&t=1053"
echo
echo "---------------------------------------------------------------------------------------"

# get page contents and store it all in a variable (no external files needed)
${curlbin} --silent "${keypage}" -o "${keypagetmp}"

# make sure key page was downloaded (or at least _SOMETHING_ was downloaded)
if [ ! -f "${keypagetmp}" ]; then
    echo "[E]: The temporary page can not be found."
    echo "[E]: The 'keypagetmp' variable at the top of this script"
    echo "[E]: points to: ${keypagetmp}"
    echo
    echo "Make sure the directory in the 'keypagetmp' variable is writable by the user running this script."
    echo "There is also a possibility that the page could not be retrieved. No network. Page moved (doubtful),"
    echo "or some other error from 'curl'."
    exit
fi

# weed out the registration code and save it in a variable
makemkv_reg_key="$(${grepbin} "code>T-" "${keypagetmp}" | ${sedbin} -e 's/.*<pre><code>//' -e 's/<.*$//')"

# display registration code
echo "Registration code: ${makemkv_reg_key}"

# weed out the expiration date and save it in a variable
makemkv_reg_date="$(${grepbin} "valid until" "${keypagetmp}" | ${sedbin} -e 's/^.*valid until //' -e 's/\..*$//')"

# display expiration date
echo " Code Valid Until: ${makemkv_reg_date}"
echo "---------------------------------------------------------------------------------------"

# remove temporary file
if [ -f "${keypagetmp}" ]; then
    ${rmbin} "${keypagetmp}"
fi

# print extra line for cleanliness
echo

