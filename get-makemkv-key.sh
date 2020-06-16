#!/usr/bin/env bash
scriptversion="trunk"
scriptlastedit="20200615"
scriptauthor="John Pyper"
scriptsite="https://github.com/jpyper/bash-scripts"




# quick way to get the most current MakeMKV registration key while it is still in beta (forever?).


########################
### [ USER OPTIONS ] ###
########################

# url to forum post where makemkv key is posted
keypage="https://www.makemkv.com/forum/viewtopic.php?f=5&t=1053"

# we assume the 'which' is included with the base system at install time. if not, install it, type 'which which' and change the 'whichbin' variable below.
# on manjaro: core/which, binary located at /usr/bin/which
# on debian: debianutils, binary located at /bin/which
# on ubuntu: debianutils, binary located at /bin/which
whichbin="/usr/bin/which"

# where is the 'curl' binary
curlbin="$(${whichbin} curl)"

# where is the 'grep' binary
grepbin="$(${whichbin} grep)"

# where is the 'sed' binary
sedbin="$(${whichbin} sed)"

#####################################################################################################

##################################
### [ CHECK FOR DEPENDENCIES ] ###
##################################

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


# curl --silent "https://www.makemkv.com/forum/viewtopic.php?f=5&t=1053" | grep "code>T-" | sed -e 's/.*<pre><code>//' -e 's/<.*$//'

#############################
### [ DO THE DIRTY WORK ] ###
#############################

# let's start with a blank screen
clear

# display script header
echo
echo "+-----------------------------------------------"
echo "| MakeMKV Beta Registration Key"
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


