#!/bin/bash

PS3="Select an option: "
OPTIONS=(
	"Set Hostname"
	"Remove Firefox RPMs"
	"Install Flatpaks"
	"Steam Input Rules"
	"All Options"
)

function all-options() {
	setup-hostname
	remove-firefox
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
	flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
	echo -e "\nInstalling flatpaks..."
	flatpak install --assumeyes --user flathub $(cat flatpaks.txt)
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
        setup-hostnameecho ""
}

clear
while true
do
	select OPT in "${OPTIONS[@]}" Quit
	do
		case $REPLY in
			1) setup-hostname; break;;
			2) remove-firefox; break;;
			3) setup-flatpaks; break;;
			4) steam-input; break;;
			5) all-options; break;;
			$((${#OPTIONS[@]}+1))) break 2;;
			*) echo "Invalid option: $REPLY"; break;;
		esac
	done
done
