vmxcfg="/Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx"

if ! [ -e "${vmxcfg}" ]; then

	echo "VMX config exist"
	echo "Backing up current config"
	echo ""
	cp /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan_backup.vmx

	curr0=$(grep "usb.autoConnect.device0" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx)
	curr1=$(grep "usb.autoConnect.device1" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx)
	curr2=$(grep "usb.autoConnect.device2" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx)

	echo "USB auto connect values prior to changing"
	echo $curr0
	echo $curr1
	echo $curr2
	echo ""

	new0='usb.autoConnect.device0 = "0x082B:0x0007 autoclean:0"'
	new1='usb.autoConnect.device1 = "0x082B:0x1003 autoclean:0"'
	new2='usb.autoConnect.device2 = "0x0B95:0x7720 autoclean:0"'

	echo "Updating USB auto connect values"
	sed -i '' -e 's/'"$curr0"'/'"$new0"'/g' /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
	sed -i '' -e 's/'"$curr1"'/'"$new1"'/g' /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
	sed -i '' -e 's/'"$curr2"'/'"$new2"'/g' /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx

	curr3=$(grep "usb.autoConnect.device0" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx)
	curr4=$(grep "usb.autoConnect.device1" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx)
	curr5=$(grep "usb.autoConnect.device2" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx)

	echo ""
	echo "USB auto connect values after changing"
	echo $curr3
	echo $curr4
	echo $curr5

fi
exit
