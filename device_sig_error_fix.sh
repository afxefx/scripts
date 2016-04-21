#!/bin/bash

qaURL=$1


if /sbin/ping -oq $2 &> /dev/null

    then

    /bin/echo "grabbing package"
    /usr/bin/curl --silent --output QuickAdd-Clinic.zip "$qaURL"

    /bin/echo "unzipping package"
    sudo unzip QuickAdd-Clinic.zip -d .;sudo rm -rf __MACOSX

    /bin/echo "updating time"
    sudo ntpdate -u $(systemsetup -getnetworktimeserver|awk '{print $4}')

    /bin/echo "removing jamf framework"
    sudo jamf removeFramework -verbose

    /bin/echo "installing QuickAdd package"
    sudo installer -dumplog -verbose -pkg QuickAdd-Clinic.pkg -target /

    /bin/echo "running a(nother) recon"
    sudo /usr/local/bin/jamf recon -verbose

## Thanks to Rich Trouton for the following gem!    

    ## /bin/echo "installing CasperCheck"
    ## sudo /usr/local/bin/jamf policy -trigger installCasperCheck


    ## /bin/echo "flushing policy history"
    ## sudo /usr/local/bin/jamf flushPolicyHistory

    ## /bin/echo "running policy"
    ## sudo /usr/local/bin/jamf policy -verbose

    rm -rf ./QuickAdd-Clinic.zip
    rm -rf ./QuickAdd-Clinic.pkg

else

/bin/echo "Can't reach Casper.  Quitting."

fi

exit 0