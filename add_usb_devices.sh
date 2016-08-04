#!/bin/bash
vmxcfg="/Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx"

if ! [ -e "${vmxcfg}" ]; then

	echo "VMX config exist"
	echo "Backing up current config"
	echo ""
	cp /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan_backup.vmx

	echo "Config file currently contains:"
	current=$(grep "usb.autoConnect" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx)
	echo $current

	curr0=$(grep "usb.autoConnect.device0" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx)
	curr1=$(grep "usb.autoConnect.device1" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx)

	new0='usb.autoConnect.device0 = "vid:082b autoclean:0"'
	new1='usb.autoConnect.device1 = "vid:0b95 autoclean:0"'

	echo "Updating USB auto connect values"
	sed -i '' -e 's/'"$curr0"'/'"$new0"'/g' /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
	sed -i '' -e 's/'"$curr1"'/'"$new1"'/g' /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
	sed -i '' -e '/'usb.autoConnect.device2'/d' /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
	sed -i '' -e '/'usb.autoConnect.device3'/d' /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
	echo ""

	echo "Config file after alterations:"
	new=$(grep "usb.autoConnect" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx)
	echo $new

fi
exit
