#!/bin/bash

PS3="Select an option: "
OPTIONS=(
	"Set Hostname"
	"Install RPMs"
	"Install Flatpaks"
	"Steam Input Rules"
)

function setup-flatpaks() {
	echo -e "\nAdding Flathub..."
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	echo -e "\nInstalling flatpaks..."
	flatpak install -y flathub $(cat flatpak-packages.txt)
	echo ""
}

function setup-hostname() {
	echo -e "\nWARNING - New hostname will not take affect until the next reboot.\n"
	read -p "Hostname: " host
	sudo hostnamectl set-hostname $host
	echo ""
}

function setup-rpms() {
	echo -e "\nWARNING - A reboot will be required before packages are enabled."
	echo -e "\nInstalling packages..."
	rpm-ostree install -y $(cat rpm-packages.txt)
	echo ""
}

function steam-input() {
	echo -e "\nWARNING - A reboot will be required before rules are enabled."
        echo -e "\nAdding Steam input rules..."
        sudo wget https://raw.githubusercontent.com/ValveSoftware/steam-devices/master/60-steam-input.rules -O /etc/udev/rules.d/60-steam-input.rules
        echo ""
}

clear
while true
do
	select OPT in "${OPTIONS[@]}" Quit
	do
		case $REPLY in
			1) setup-hostname; break;;
			2) setup-rpms; break;;
			3) setup-flatpaks; break;;
			4) steam-input; break;;
			$((${#OPTIONS[@]}+1))) break 2;;
			*) echo "Invalid option: $REPLY"; break;;
		esac
	done
done
