#!/bin/bash
scriptversion="trunk"
scriptlastedit="20150912"
scriptauthor="John Pyper"
scriptsite="https://github.com/jpyper/bash-scripts"



#############
### ABOUT ###
#############
#  This is a simple script to install/update/uninstall Google Web Fonts from GitHub.

#  More information about Google Web Fonts can be found at:
#+ https://www.google.com/fonts

#  I have only tested this script on the following Linux distributions:
#+ Debian
#+ Ubuntu
#+ Manjaro
#+ Fedora

#  I would like to know if this script works on *BSD/*Solaris/Mac systems. Please
#+ file a GitHub bug report with your findings, as I do not have these available
#+ to do the tests myself.

#  It is probably best to install the Google Web Fonts to a system-wide directory
#+ so they may be used by all users on the system.

#  All "system" options require superuser privileges.
#+ Example:
#+ 	googlefonts.sh install system
#+ 	googlefonts.sh update system
#+ 	googlefonts.sh uninstall system


####################
### REQUIREMENTS ###
####################
# git, which, mkdir, rm


###############
### LICENSE ###
###############
#  This script is licensed under the MIT License.
#+ Details here: http://opensource.org/licenses/MIT


############################
### CONFIGURABLE OPTIONS ###
############################

# user directory
gfuser="${HOME}/.fonts"

# system-wide directory
gfsys="/usr/local/share/fonts"

# font directory name
gfdir="google-fonts"

# github google fonts repository
gfghrepo="https://github.com/google/fonts"

# git executable
gitbin=$(which git)

# fontconfig fc-cache executable
fccachebin=$(which fc-cache)


###################
### MAGIC BELOW ###
###################

if [ ! -f ${fccachebin} ]; then
	echo
	echo "The \"fc-cache\" executable was not found."
	echo
	echo "Please install the \"fontconfig\" package."
	echo
	exit
fi

if [ ! -f ${gitbin} ]; then
	echo
	echo "The \"git\" executable was not found."
	echo
	echo "Please install the \"git\" or \"git-core\" package."
	echo
	exit
fi

### lazy conversion of command line options
gfact="$1"
gfopt="$2"


#################
### FUNCTIONS ###
#################

###[ "install" functions ]###

gfInstallUser () {
	echo "INSTALL USER"
	echo

	# install user

	if [ -d "${gfuser}/${gfdir}" ]; then
		# user font directory exists
		echo
		echo "USER: Google Web Fonts is already installed."
		echo "${gfuser}/${gfdir}"
		echo
		echo "USER: Installation aborted."
		echo
		exit
	else
		# create user font directory
		echo
		echo "USER: Creating directory for Google Web Fonts."
		echo "${gfuser}/${gfdir}"
		mkdir -p "${gfuser}/${gfdir}"
		echo

		# change to user directory
		cd "${gfuser}"

		# use git to download google font repository
		echo "USER: Cloning Google Web Fonts from GitHub repository:"
		echo "${gfghrepo}"
		echo
		${gitbin} clone ${gfghrepo}.git ${gfdir}
		echo

		# update user font cache
		echo "USER: Updating font cache."
		${fccachebin} -f
		echo

		# finish message
		echo "USER: Google Web Fonts installation is complete."
		echo
		echo "You may need to LOGOUT of your session and LOGIN again for Google Web Fonts to be usable."
		echo
	fi
}

gfInstallSystem () {
	echo "INSTALL SYSTEM"
	echo

	# install system

	if [ -d "${gfsys}/${gfdir}" ]; then
		# system font directory exists
		echo
		echo "SYSTEM: Google Web Fonts is already installed."
		echo "${gfsys}/${gfdir}"
		echo
		echo "SYSTEM: Installation aborted."
		echo
		exit
	else
		# create system font directory
		echo
		echo "SYSTEM: Creating directory for Google Web Fonts."
		echo "${gfsys}/${gfdir}"
		sudo mkdir -p "${gfsys}/${gfdir}"
		echo

		# change to system directory
		cd "${gfsys}"

		# use git to download google font repository
		echo "SYSTEM: Cloning Google Web Fonts from GitHub repository:"
		echo "${gfghrepo}"
		echo
		sudo ${gitbin} clone ${gfghrepo}.git ${gfdir}
		echo

		# update system font cache
		echo "SYSTEM: Updating font cache."
		sudo ${fccachebin} -f
		echo

		# finish message
		echo "SYSTEM: Google Web Fonts installation is complete."
		echo
		echo "You may need to LOGOUT of your session and LOGIN again for Google Web Fonts to be usable."
		echo
	fi
}

gfInstallHelp () {
	echo "INSTALL HELP"
	echo
	echo "install OPTIONS:"
	echo
	echo "googlefonts.sh install user	= Install Google Web Fonts to ${gfuser}/${gfdir}"
	echo "googlefonts.sh install system	= Install Google Web Fonts to ${gfsys}/${gfdir}"
	echo "googlefonts.sh install help	= this help screen"
	echo
	exit
}


###[ "update" functions ]###

gfUpdateUser () {
	echo "UPDATE USER"
	echo

	# update user

	# check for user font installation
	if [ -d "${gfuser}/${gfdir}" ]; then

		# change to user font directory
		cd "${gfuser}/${gfdir}"

		# update from repo
		echo "USER: Checking for Google Web Font updates."
		${gitbin} pull
		echo

		# update user font cache
		echo "USER: Updating font cache."
		${fccachebin} -f
		echo

		# finish message
		echo "USER: Google Web Fonts update completed."
		echo
		echo "You may need to LOGOUT of your session and LOGIN again for Google Web Fonts to be usable."
		echo
		exit
	else
		# display user directory not found message then quit
		echo
		echo "USER: Expected Google Web Fonts directory not found."
		echo "${gfsys}/${gfdir}"
		echo
		echo "USER: Google Web Fonts update not possible."
		echo
		exit
	fi
}

gfUpdateSystem () {
	echo "UPDATE SYSTEM"
	echo

	# update system

	# check for system font installation
	if [ -d "${gfsys}/${gfdir}" ]; then
		# change to system font directory
		cd "${gfsys}/${gfdir}"

		# update from repo
		echo "SYSTEM: Checking for Google Web Fonts updates."
		sudo ${gitbin} pull
		echo

		# update system font cache
		echo "SYSTEM: Updating font cache."
		sudo ${fccachebin} -f
		echo

		# finish message
		echo "SYSTEM: Google Web Fonts update completed."
		echo
		echo "You may need to LOGOUT of your session and LOGIN again for Google Web Fonts to be usable."
		echo
		exit
	else
		# display directory not found message then quit
		echo
		echo "SYSTEM: Expected Google Web Fonts directory not found."
		echo "${gfsys}/${gfdir}"
		echo
		echo "SYSTEM: Google Web Fonts update not possible."
		echo
		exit 1
	fi
}

gfUpdateHelp () {
	echo "UPDATE HELP"
	echo
	echo "update OPTIONS:"
	echo
	echo "googlefonts.sh update user	= Update/Check Google Web Fonts in ${gfuser}/${gfdir}"
	echo "googlefonts.sh update system	= Update/Check Google Web Fonts in ${gfsys}/${gfdir}"
	echo "googlefonts.sh update help	= this help screen"
	echo
	exit
}


###[ "uninstall" functions ]###

gfUninstallUser () {
	echo "UNINSTALL USER"
	echo

	# uninstall user

	if [ -d "${gfuser}/${gfdir}" ]; then
		echo
		echo "USER: Are you sure you want to remove Google Web Fonts?"
		echo "${gfuser}/${gfdir}"
		echo "[y/n] "
		read gfdeluserdir
		case "${gfdeluserdir}" in
			[Yy]|[Yy][Ee][Ss])
				# delete user fonts
				echo
				echo "USER: Removing Google Web Fonts directory."
				rm -rf "${gfuser}/${gfdir}"
				echo

				# update user font cache
				echo "USER: Updating font cache."
				${fccachebin} -f
				echo

				# final message
				echo "USER: Google Web Fonts uninstallation is complete."
				echo
				echo "You may need to LOGOUT of your session and LOGIN again for Google Web Fonts to be usable."
				echo
				;;

			[Nn]|[Nn][Oo])
				# abort the mission!
				echo
				echo "USER: Google Web Fonts uninstall was not performed."
				echo
				;;

			*)
				# try again?
				;;
		esac
		exit
	else
		echo "USER: Expected Google Web Fonts directory not found."
		echo "${gfuser}/${gfdir}"
		echo
		echo "USER: Google Web Fonts uninstall not possible."
		echo
		exit
	fi
}

gfUninstallSystem () {
	echo "UNINSTALL SYSTEM"
	echo

	# uninstall user

	if [ -d "${gfsys}/${gfdir}" ]; then
		echo
		echo "SYSTEM: Are you sure you want to remove Google Web Fonts?"
		echo "${gfsys}/${gfdir}"
		echo "[y/n] "
		read gfdelsysdir
		case "${gfdelsysdir}" in
			[Yy]|[Yy][Ee][Ss])
				# delete system fonts
				echo
				echo "SYSTEM: Removing Google Web Fonts directory."
				sudo rm -rf "${gfsys}/${gfdir}"
				echo

				# update system font cache
				echo "SYSTEM: Updating font cache."
				sudo ${fccachebin} -f
				echo

				# final message
				echo "SYSTEM: Google Web Fonts uninstallation is complete."
				echo
				echo "You may need to LOGOUT of your session and LOGIN again for Google Web Fonts to be usable."
				echo
				;;

			[Nn]|[Nn][Oo])
				# abort the mission!
				echo
				echo "SYSTEM: Google Web Fonts uninstall was not performed."
				echo
				;;

			*)
				# try again?
				;;
		esac
		exit
	else
		echo "SYSTEM: Expected Google Web Fonts directory not found."
		echo "${gfsys}/${gfdir}"
		echo
		echo "SYSTEM: Google Web Fonts uninstall not possible."
		echo
		exit
	fi
}

gfUninstallHelp () {
	echo "UNINSTALL HELP"
	echo
	echo "uninstall OPTIONS:"
	echo
	echo "googlefonts.sh uninstall user	= Uninstall Google Web Fonts from ${gfuser}/${gfdir}"
	echo "googlefonts.sh uninstall system	= Uninstall Google Web Fonts from ${gfsys}/${gfdir}"
	echo "googlefonts.sh uninstall help	= this help screen"
	echo
	exit
}


###[ "help" functions ]###

gfHelp () {
	echo "HELP"
	echo
	echo "ACTIONS and their OPTIONS:"
	echo
	echo "googlefonts.sh install user	= Install Google Web Fonts to ${gfuser}/${gfdir}"
	echo "googlefonts.sh install system	= Install Google Web Fonts to ${gfsys}/${gfdir}"
	echo "googlefonts.sh install help	= install options help screen"
	echo
	echo "googlefonts.sh update user	= Update/Check Google Web Fonts in ${gfuser}/${gfdir}"
	echo "googlefonts.sh update system	= Update/Check Google Web Fonts in ${gfsys}/${gfdir}"
	echo "googlefonts.sh update help	= update options help screen"
	echo
	echo "googlefonts.sh uninstall user	= Uninstall Google Web Fonts from ${gfuser}/${gfdir}"
	echo "googlefonts.sh uninstall system	= Uninstall Google Web Fonts from ${gfsys}/${gfdir}"
	echo "googlefonts.sh uninstall help	= uninstall options help screen"
	echo
	echo "googlefonts.sh help		= this help screen"
	echo "googlefonts.sh			= this help screen"
	echo
	exit
}





######################################
### ALL YOUR BITS ARE BELONG TO US ###
######################################

# let's start with a blank screen
clear

# display script header
echo
echo "+-----------------------------------------------"
echo "| Google Web Fonts Manager"
echo "| version: ${scriptversion} (${scriptlastedit})"
echo "| by: ${scriptauthor}"
echo "| web: ${scriptsite}"
echo

case "${gfact}" in
	[Ii][Nn][Ss][Tt][Aa][Ll][Ll])
		# install
		case "${gfopt}" in
			[Uu][Ss][Ee][Rr])
				# user
				gfInstallUser
				;;
			[Ss][Yy][Ss][Tt][Ee][Mm])
				# system
				gfInstallSystem
				;;
			[Hh][Ee][Ll][Pp])
				# help
				gfInstallHelp
				;;
			*)
				# whatchu talkin bout willis
				gfInstallHelp
				;;
		esac
		;;
	[Uu][Pp][Dd][Aa][Tt][Ee])
		# update
		case "${gfopt}" in
			[Uu][Ss][Ee][Rr])
				# user
				gfUpdateUser
				;;
			[Ss][Yy][Ss][Tt][Ee][Mm])
				# system
				gfUpdateSystem
				;;
			[Hh][Ee][Ll][Pp])
				# help
				gfUpdateHelp
				;;
			*)
				# help
				gfUpdateHelp
				;;
		esac
		;;
	[Uu][Nn][Ii][Nn][Ss][Tt][Aa][Ll][Ll])
		# uninstall
		case "${gfopt}" in
			[Uu][Ss][Ee][Rr])
				# user
				gfUninstallUser
				;;
			[Ss][Yy][Ss][Tt][Ee][Mm])
				# system
				gfUninstallSystem
				;;
			[Hh][Ee][Ll][Pp])
				# help
				gfUninstallHelp
				;;
			*)
				# help
				gfUninstallHelp
				;;
		esac
		;;
	[Hh][Ee][Ll][Pp])
		# help
		gfHelp
		;;
	*)
		# help
		gfHelp
		;;
esac
