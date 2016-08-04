currentWANIP=$(curl -s icanhazip.com)
echo "WAN IP of current location is $currentWANIP"

ddnsIP=$(host illshowu.ddns.net |  awk '{ print $4}')
echo "Public IP of dynamic hostname is $ddnsIP"

if [ "$currentWANIP" != "$ddnsIP" ] ; then 
        echo "IP mismatch, out and about I presume so VPN for you"
        sudo openvpn --config /home/pi/client1.ovpn &
        sleep 15
        sudo mount -t cifs -o password=blah //192.168.1.1/DATA/roms /home/pi/RetroPie/roms
        sleep 5
        if [ -d /home/pi/RetroPie/roms/gba ]; then
                mv /home/pi/RetroPie/roms/gba /home/pi/RetroPie/roms/gba_vpn
        fi
        if [ -d /home/pi/RetroPie/roms/gbc ]; then
                mv /home/pi/RetroPie/roms/gbc /home/pi/RetroPie/roms/gbc_vpn
        fi
        if [ -d /home/pi/RetroPie/roms/megadrive ]; then
                mv /home/pi/RetroPie/roms/megadrive /home/pi/RetroPie/roms/megadrive_vpn
        fi
        if [ -d /home/pi/RetroPie/roms/n64 ]; then
                mv /home/pi/RetroPie/roms/n64 /home/pi/RetroPie/roms/n64_vpn
        fi
        echo "Disabled larger ROM folders to decrease boot time"
else
        echo "IP match, you must be at home so no VPN for you"
        sudo mount -t cifs -o password=blah //192.168.1.1/DATA/roms /home/pi/RetroPie/roms
        sleep 5
        if [ -d /home/pi/RetroPie/roms/gba_vpn ]; then
                mv /home/pi/RetroPie/roms/gba_vpn /home/pi/RetroPie/roms/gba
        fi
        if [ -d /home/pi/RetroPie/roms/gbc_vpn ]; then
                mv /home/pi/RetroPie/roms/gbc_vpn /home/pi/RetroPie/roms/gbc
        fi
        if [ -d /home/pi/RetroPie/roms/megadrive_vpn ]; then
                mv /home/pi/RetroPie/roms/megadrive_vpn /home/pi/RetroPie/roms/megadrive
        fi
        if [ -d /home/pi/RetroPie/roms/n64_vpn ]; then
                mv /home/pi/RetroPie/roms/n64_vpn /home/pi/RetroPie/roms/n64
        fi
        echo "Enabled all ROM folders"
fi