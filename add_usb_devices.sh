#!/bin/bash
vmxcfg="/Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx"

if ! [ -e "${vmxcfg}" ]; then
        echo "VMX config exist"
        echo "Backing up current config"
        echo ""
        cp /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx.bak

        echo "Config file currently contains:"
        grep "usb.autoConnect" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx

        total=$(grep -r "usb.autoConnect" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx | grep -c "autoConnect")
        new0='usb.autoConnect.device0 = "vid:082b autoclean:0"'
        new1='usb.autoConnect.device1 = "vid:0b95 autoclean:0"'
        new2='usb.autoConnect.device2 = "vid:0fe2 autoclean:0"'
                
        echo ""
        echo "Updating USB auto connect values"
        sed -i '' -e '/'usb.autoConnect.device*'/d' /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
        #sed -i '' -e 's/'"$curr1"'/'"$new1"'/g' /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
        #sed -i '' -e 's/'"$curr2"'/'"$new2"'/g' /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
        #sed -i '' -e '/'usb.autoConnect.device3'/d' /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
        echo $new0 >> /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
        echo $new1 >> /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
        echo $new2 >> /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
        echo ""

        echo "Config file after alterations:"
        grep "usb.autoConnect" /Library/Application\ Support/VMware/Aycan.vmwarevm/Aycan.vmx
fi
exit
