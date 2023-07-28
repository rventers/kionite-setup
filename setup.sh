#!/bin/bash

PS3="Select an option: "
OPTIONS=(
	"Set Hostname"
	"Install Flatpaks"
	"Steam Input Rules"
	"Rebase to Bazzite"
	"All options"
)

function all-options() {
	set-hostname
	install-flatpaks
	steam-input
	rebase-bazzite
}

function install-flatpaks() {
	echo -e "\nAdding Flathub..."
	flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
	echo -e "\nInstalling flatpaks..."
	flatpak install --assumeyes --user flathub $(cat flatpaks.txt)
	echo ""
}

function rebase-bazzite() {
	echo -e "\nRebasing to Bazzite..."
	podman pull ghcr.io/ublue-os/config && rpm-ostree install --assumeyes --apply-live --force-replacefiles $(find ~/.local/share/containers -name ublue-os-signing.noarch.rpm 2>/dev/null) && rpm-ostree rebase --uninstall $(rpm -q ublue-os-signing-* --queryformat '%{NAME}-%{VERSION}-%{RELEASE}.%{Arch}') ostree-image-signed:docker://ghcr.io/ublue-os/bazzite:latest
	echo ""
}

function set-hostname() {
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

clear
while true
do
	select OPT in "${OPTIONS[@]}" Quit
	do
		case $REPLY in
			1) set-hostname; break;;
			2) install-flatpaks; break;;
			3) steam-input; break;;
			4) rebase-bazzite; break;;
			5) all-options; break;;
			$((${#OPTIONS[@]}+1))) break 2;;
			*) echo "Invalid option: $REPLY"; break;;
		esac
	done
done
