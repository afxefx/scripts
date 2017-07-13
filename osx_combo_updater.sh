#!/bin/bash
# Purpose: Download and install Mac OS X’s combo updater
#
# From:	Tj Luo.ma
# Mail:	luomat at gmail dot com
# Web: 	http://RhymesWithDiploma.com
# Date:	2014-05-15

	# This is the only thing you _have_ to change
URL="$1"

# You shouldn't need to change anything below this line.

	# This is where the combo DMG will be downloaded to
DIR="/tmp"

	# this is the name of this script, minus the path and extension
NAME="$0"

	# This is where we will log what happens
LOG="/tmp/$NAME.log"

################################################################################################



FILENAME=$(echo "${URL##*/}")

REMOTE_SIZE=`curl --fail --head --location --silent "$URL" \
| egrep '^Content-Length' \
| tail -1 \
| tr -dc '[0-9]'`

	# needed for zstat and $EPOCHSECONDS
#zmodload zsh/stat
#zmodload zsh/datetime

timestamp () {
	#strftime "%Y-%m-%d %H:%M:%S" "$EPOCHSECONDS"
	date
}

function log {
	echo "$NAME [`timestamp`]: $@" | tee -a "$LOG"
}

function die {
	echo "$NAME [`timestamp`]: FATAL ERROR $@" | tee -a "$LOG"
	exit 1
}



LATEST_VERSION=`echo "$FILENAME" | cut -c 12- | cut -c -7`

INSTALLED_VERSION=`sw_vers -productVersion`

function version { echo "$@" | awk -F. '{ printf("15%03d%03d%03d\n", $1,$2,$3,$4); }'; }

if [ $(version ${LATEST_VERSION}) -gt $(version ${INSTALLED_VERSION}) ]
then
	log "Update required: $INSTALLED_VERSION < $LATEST_VERSION"

		# if an update is required
		# And if we are not in launchd
		# and if the EUID is not root
		# then get the user to enter their `sudo` creds
	PPID_NAME=$(command ps -o 'command=' -cp ${PPID} 2>/dev/null )

	if [ "$PPID_NAME" != "launchd" ]
	then
		if [ "$EUID" != "0" ]
		then
			sudo -v || die "Failed to authenticate with 'sudo'."
		fi
	fi
else
	log "No update required: Installed: $INSTALLED_VERSION  Latest: $LATEST_VERSION"
	exit 0
fi

function mntdmg {

	log "Attempting to mount $FILENAME"

	MNTPNT=`hdid -nobrowse -plist "$FILENAME" |\
	fgrep -A 1 '<key>mount-point</key>' |\
	tail -1 |\
	sed 's#</string>.*##g ; s#.*<string>##g'`
}

function pkginstall {

	PKG=`find "$MNTPNT" -iname \*pkg -maxdepth 2 -print`

	[[ "$PKG" == "" ]] && die "PKG is empty"

	INSTALLED='no'

	log "Starting installation of $PKG"

	sudo installer -verboseR -pkg "$PKG" -target / -lang en 2>&1 | tee -a "$LOG"

	EXIT="$?"

	if [ "$EXIT" = "0" ]
	then
		log "SUCCESS: Installation of $PKG "
		INSTALLED='yes'
	else
		log "FAILED to install $PKG (\$EXIT = $EXIT)"
		INSTALLED='no'
	fi
}

function fetch {

	log "Attempting to fetch $URL to $PWD/$FILENAME"

	curl --fail --location --continue-at - --output "$FILENAME" "$URL"

	EXIT="$?"

	if [ "$EXIT" = "0" ]
	then
		FETCH_RESULT='success'
		log "SUCCESS: fetched $URL to $PWD/$FILENAME"
	else
		FETCH_RESULT='failure'
		log "FAILED to fetch URL to $PWD/$FILENAME (\$EXIT = $EXIT)"
	fi
}

################################################################################################

cd "$DIR"

if [ -e "$FILENAME" ]
then
	LOCAL_SIZE=`stat -L "$FILENAME" | awk {'print $8'}`
else
	LOCAL_SIZE='0'
fi

COUNT='0'

while [ "$LOCAL_SIZE" -lt "$REMOTE_SIZE" ]
do
	((COUNT++))

	if [ "$COUNT" -lt "10" ]
	then
		fetch

		LOCAL_SIZE=`stat -L "$FILENAME" | awk {'print $8'}`

	else
		MSG="We failed to fetch $URL to $DIR/$FILENAME after $COUNT attempts. Giving up."

		die "$MSG"
	fi
done

	# mount the DMG
mntdmg

[[ "$MNTPNT" == "" ]] && die "MNTPNT is empty"

	# Install the PKG from the mounted DMG
pkginstall

if [ "$INSTALLED" = "yes" ]
then

	sudo shutdown -r +1

	log "Rebooting in one minute"

else

	die "Installation failed, not rebooting"

fi

exit
#
#EOF
