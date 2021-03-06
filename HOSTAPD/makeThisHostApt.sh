#!/bin/bash

[[ $USER == "root" ]] && echo "run as regular user and pass in password when asked" && exit

echo "Will change lighttpd to run under $USER credentials"
echo "WIll enable elan1 as HOSTAPD with address 10.5.5.1, and AP name cocam"

echo "Do you want to test this before installing ?"
read yn
if [[ $yn == 'y' ]];then
 	OU="OUT"
else
	OU=""
fi

if [[ $OU == "OUT" ]];then
	echo "testing mode"
fi
#sudo apt-get update
#sudo apt-get -y install lighttpd php5-cgi
##sudo apt-get -y install --reinstall hostapd
#sudo apt-get install dnsmasq
#sudo usermod -a -G www-data $USER
#sudo lighty-enable-mod fastcgi-php
#sudo service lighttpd stop

echo "Here are the network interfaces" 
ifconfig -a | grep Link
echo "Please enter the wlan on which hostapd would run?"
read WLAN
SSID=$(echo $(cat /proc/cpuinfo | grep Serial | awk '{print $3}') | tail -c 9)

echo "Adding hostapd SSID=cam_$SSID"

for f in $(ls -a *@*);do
	dest=$OU$(echo @"$f" | tr '@' '/')
	cp $f /tmp/abc.txt
        sed -i "s/\$USER/$USER/g" "/tmp/abc.txt"
        sed -i "s/\$SSID/$SSID/g" "/tmp/abc.txt"
        sed -i "s/\$WLAN/$WLAN/g" "/tmp/abc.txt"

	if [[ "$f" =~ "etc" ]];then
		echo "Installing as root root: $f -> $dest"
		[[ ! -f "$dest"-old ]] &&  sudo cp -fv "$dest" "$dest"-old
		mkdir -p $(dirname $dest)
		sudo cp -f /tmp/abc.txt $dest
		chmod +x $dest
	else
		destok=$(echo $dest | sed "s/\$USER/$USER/")
		echo "Installing as $USER: $f -> $destok"
		[[ ! -f "$destok"-old ]] && cp "$dest" "$destok"-old
		mkdir -p $(dirname $destok)
		cp -f /tmp/abc.txt -fv $destok
		chmod +x $destok
	fi
	rm /tmp/abc.txt
done

if [[ $OU == "OUT" ]];then
	echo "CHECK OUT FOLDER TO SEE HOW SYSTEM IS PATCHED"
else

	sudo chmod +x /etc/init.d/autostart
	sudo update-rc.d autostart remove
	chmod +x $HOME/autostart
	chmod +x $HOME/autostart-root
	sudo ./honeypot.sh $WLAN

	sudo update-rc.d hostapd disable
	sudo update-rc.d hostapd remove      # start from auto
	sudo update-rc.d dnsmasq defaults
	sudo update-rc.d lighttpd defaults
fi

