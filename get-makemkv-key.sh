#!/usr/bin/env bash
scriptversion="trunk"
scriptlastedit="20200616"
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
# url to forum post where makemkv key is posted
keypage="https://www.makemkv.com/forum/viewtopic.php?f=5&t=1053"
# where is the 'curl' binary
curlbin="$(type -P curl)"
# where is the 'grep' binary
grepbin="$(type -P grep)"
# where is the 'sed' binary
sedbin="$(type -P sed)"
#####################################################################################################


#####################
### [ CHANGELOG ] ###
#####################
# 20200616:
#   - removed occurances of using 'which' to find commands
#   + use BASH's built-in 'type -P' to find commands faster
#   + add BASH version check to DEPENDENCIES CHECK section
#   + add MIT license
#   + add this CHANGELOG section
#
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

# check BASH version. this script needs version 4.0 or higher to use 'type -P' to find files.
if [[ "$(echo "${BASH_VERSION}" | ${sedbin} -e 's/\..*$//')" -lt "4" ]]; then
    echo "[E]: Script requires BASH version 4.0 or higher to work."
    exit
fi

# check for 'curl' binary
if [[ ! -f "${curlbin}" ]]; then
	echo "[E]: curl binary not found."
	echo "[E]: the 'curlbin' variable at the top of this script"
	echo "[E]: points to: ${curlbin}"
	echo
	echo "Check your package manager for 'curl' and install it, or"
	echo "set the proper path in the 'curlbin' variable."
	exit
fi

# check for 'grep' binary
if [[ ! -f "${grepbin}" ]]; then
	echo "[E]: grep binary not found."
	echo "[E]: the 'grepbin' variable at the top of this script"
	echo "[E]: points to: ${grepbin}"
	echo
	echo "Check your package manager for 'grep' and install it, or"
	echo "set the proper path in the 'grepbin' variable."
	exit
fi

# check for 'sed' binary
if [[ ! -f "${sedbin}" ]]; then
	echo "[E]: sed binary not found."
	echo "[E]: the 'sedbin' variable at the top of this script"
	echo "[E]: points to: ${sedbin}"
	echo
	echo "Check your package manager for 'sed' and install it, or"
	echo "set the proper path in the 'sedbin' variable."
	exit
fi

#####################################################################################################





#############################
### [ DO THE DIRTY WORK ] ###
#############################

# let's start with a blank screen
clear

# display script header
echo
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
makemkv_key_forum_post="$(curl --silent "https://www.makemkv.com/forum/viewtopic.php?f=5&t=1053")"

# weed out the registration code and save it in a variable
makemkv_reg_key="$(echo ${makemkv_key_forum_post} | ${grepbin} "code>T-" | ${sedbin} -e 's/.*<pre><code>//' -e 's/<.*$//')"

# display registration code
echo "Registration code: ${makemkv_reg_key}"

# weed out the expiration date and save it in a variable
makemkv_reg_date="$(echo ${makemkv_key_forum_post} | ${sedbin} -e 's/^.*valid until //' -e 's/\..*$//')"

# display expiration date
echo " Code Valid Until: ${makemkv_reg_date}"
echo "---------------------------------------------------------------------------------------"

# print extra line for cleanliness
echo


