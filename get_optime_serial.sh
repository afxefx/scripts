#!/bin/bash

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/Applications/VMware Fusion.app/Contents/Library"

if [[ -z $1 || -z $2 ]];then
	echo "VM credentials missing"
	exit 1
fi

RUNNING=$(vmrun list | grep -c "Aycan")
if [ $RUNNING == 0 ];then
	echo "No VMs running"
	exit 0
fi

VMPATH=`vmrun list | tail -n -1`
echo "Path to VMX file: " $VMPATH
LOGPATH=/Library/Application\ Support/VMware/OPT2016.log

if [ -f "$LOGPATH" ];then
	echo "Log file exists and will be removed"
	rm "$LOGPATH"
fi

vmrun -gu $1 -gp $2 copyFileFromGuestToHost "$VMPATH" "C:\SoredexResidentWorkingDir\OPT2016.log" "$LOGPATH"
if [ -f "$LOGPATH" ];then
	chmod 744 "$LOGPATH"
	DATE=$(grep -B2 "Software" /Library/Application\ Support/VMware/OPT2016.log | tail -n 1 | awk -F '[:,]' '{ print $1 }')
	SERIAL=$(grep "SJ" "$LOGPATH" | tail -n 1 | awk '{ print $3 }')
	echo "$SERIAL last seen on $DATE"
else
	echo "Log file does not exist"
fi
