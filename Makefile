packages = screen python3-pip python3-dev python3-rpi.gpio

## install required apt packages
apt:
	sudo apt install -y $(packages)
.PHONY: apt

## install project requirements
bootstrap: apt noswap
	sudo pip3 install -r requirements.txt
	sudo reboot
.PHONY: bootstrap

noswap:
	sudo dphys-swapfile swapoff
	sudo dphys-swapfile uninstall
	sudo update-rc.d dphys-swapfile remove
	sudo apt-get remove -y dphys-swapfile
.PHONY: noswap

## update repo and update dependencies
update: update/apt update/firmware
	git pull
	make bootstrap
.PHONY: update

update/apt:
	sudo apt-get update && sudo apt-get dist-upgrade && sudo apt-get autoclean && sudo apt-get autoremove
.PHONY: update/apt

update/firmware:
	sudo apt-get install -y rpi-update && sudo rpi-update
.PHONY: update/firmware
