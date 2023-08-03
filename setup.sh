#!/bin/bash

PS3="Select an option: "
OPTIONS=(
	"Set Hostname"
 	"Remove Firefox RPMs"
	"Upgrade System"
	"Install Flatpaks"
	"Install Steam Input Rules"
	"All Options"
)

function all-options() {
	setup-hostname
 	remove-firefox
	upgrade-system
	setup-flatpaks
	steam-input
}

function remove-firefox() {
	echo -e "\nRemoving Firefox RPMs..."
	rpm-ostree override remove firefox firefox-langpacks
	echo ""
}

function setup-flatpaks() {
	echo -e "\nRemoving system Flatpaks..."
	flatpak remote-delete fedora --force
	flatpak remove --system --noninteractive --all
	echo -e "\nAdding Flathub..."
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	echo -e "\nInstalling flatpaks..."
	flatpak install --assumeyes flathub $(cat flatpaks.txt)
	echo ""
}

function setup-hostname() {
	echo ""
	read -p "Hostname: " host
	sudo hostnamectl set-hostname $host
	echo ""
}

function steam-input() {
	echo -e "\nAdding Steam input rules..."
	sudo wget https://raw.githubusercontent.com/ValveSoftware/steam-devices/master/60-steam-input.rules -O /etc/udev/rules.d/60-steam-input.rules
	echo ""
}

function upgrade-system() {
	echo -e "\nUpgrading system..."
	rpm-ostree upgrade
	echo ""
}

clear
while true
do
	select OPT in "${OPTIONS[@]}" Quit
	do
		case $REPLY in
			1) setup-hostname; break;;
			2) remove-firefox; break;;
			3) upgrade-system; break;;
			4) setup-flatpaks; break;;
			5) steam-input; break;;
			6) all-options; break 2;;
			$((${#OPTIONS[@]}+1))) break 2;;
			*) echo "Invalid option: $REPLY"; break;;
		esac
	done
done
