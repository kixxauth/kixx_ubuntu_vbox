#!/usr/bin/env bash

fail () {
	echo "$@" >&2
	exit 1
}

echo_message () {
	echo "*******************************************************************"
	echo "$@"
	echo "*******************************************************************"
}

echo_message "Installing .bashrc"
(cp "/vagrant/.bashrc" "$HOME/" && source "$HOME/.bashrc") || fail "Unable to install .bashrc"

echo_message "Updating Ubuntu packages."
sudo apt-get update || fail "Unable to update Ubuntu packages."

echo_message "Doing an Ubuntu distribution upgrade."
sudo apt-get dist-upgrade --assume-yes || fail "Unable to update Ubuntu."

echo_message "Installing system dependencies."
sudo apt-get install build-essential git curl wget vim tree htop dkms --assume-yes || fail "Unable to install system dependencies."

echo_message "Cleaning up Ubuntu package manager."
(sudo apt-get autoremove --assume-yes && sudo apt-get autoclean --assume-yes) \
	|| fail "Unable to clean up Ubuntu package manager."
