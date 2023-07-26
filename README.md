# Post Install Helper Script for Fedora Kionite

This is a very simple script to help facilitate some post-install steps.

## Usage

1. Run the script `./kionite-setup.sh`

## Files

- **dnf-packages.txt** - This file contains a list of all applications that will be installed via the Fedora and RPMFusion repositories.
- **flatpak-packages.txt** - This file contains a list of all flat packages to install you can customise this with your choice of applications by application-id.

## Options

### Set Hostname
  - Prompts and sets the machine hostname.

### Install RPMs
  - Installs RPM packages defined in the `rpm-packages.txt` file.
  > Packages are installed via `rpm-ostree` and will require a reboot before packages are enabled.

### Install Flatpaks
  - Adds the Flathub repo if it is missing.
  - Installs Flatpak packages defined in the `flatpak-packages.txt` file.

### Steam Input Rules
  - Downloads the `60-steam-input.rules` file from the ValveSoftware steam-devices Github repo.
  > Device rules will require a reboot before they are enabled.
