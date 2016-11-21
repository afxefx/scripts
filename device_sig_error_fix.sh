#!/bin/bash

qaURL=$1
zip_name=$(echo "$qaURL" | cut -f7 -d '/')
temp_name=$(echo "$zip_name" | cut -f1 -d '.')
#echo "$temp_name"
pkg_name=$(echo "$temp_name.pkg")
#echo "$zip_name"
#echo "$pkg_name"

if /sbin/ping -oq $2 &> /dev/null

    then

    /bin/echo "grabbing package"
    /usr/bin/curl --silent --output "$zip_name" "$qaURL"

    /bin/echo "unzipping package"
    sudo unzip "$zip_name" -d .;sudo rm -rf __MACOSX

    /bin/echo "updating time"
    sudo ntpdate -u $(systemsetup -getnetworktimeserver|awk '{print $4}')

    /bin/echo "removing jamf framework"
    sudo jamf removeFramework -verbose

    /bin/echo "deleting mgt account"
    dscl . delete /Users/Casper

    /bin/echo "installing QuickAdd package"
    sudo installer -dumplog -verbose -pkg "$pkg_name" -target /

    /bin/echo "running a(nother) recon"
    sudo /usr/local/bin/jamf recon -verbose
    sleep 15
    /usr/local/bin/jamfjamf policy -id 3793
    /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -specifiedUsers
    /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -access -on -privs -DeleteFiles -ControlObserve -TextMessages -OpenQuitApps -GenerateReports -RestartShutDown -SendFiles -ChangeSettings -users Casper

## Thanks to Rich Trouton for the following gem!    

    ## /bin/echo "installing CasperCheck"
    ## sudo /usr/local/bin/jamf policy -trigger installCasperCheck


    ## /bin/echo "flushing policy history"
    ## sudo /usr/local/bin/jamf flushPolicyHistory

    ## /bin/echo "running policy"
    ## sudo /usr/local/bin/jamf policy -verbose

    rm -rf ./"$zip_name"
    rm -rf ./"$pkg_name"

else

/bin/echo "Can't reach Casper.  Quitting."

fi

exit 0