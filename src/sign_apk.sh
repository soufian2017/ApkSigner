#!/bin/bash

# [COLORS]

blue="$(tput setaf 21)"
red="$(tput setaf 160)"
reset="$(tput sgr0)"
bold="$(tput bold)"
green="$(tput setaf 2)"

# [ARGS]

key=$2
apk=$1
overwrite="y"

# [CODE]

if [ $# -ne 2 ];then
	echo "[?] Usage: $1 APK KEY$reset"
	exit
fi

if [ ! -d keys ]; then
	echo -e "$green[+] Creating keys directory$reset"
	mkdir keys
fi

if [ -f keys/$key.keystore ]; then
	read -n 1 -p "$blue[*] Key already exsists overwrite it ? (Y/n)$reset " overwrite
	echo
fi

if [ $overwrite == "y" ] || [ $overwrite == "Y" ]; then
	echo -e "$green[+] Creating a new key$reset"
	rm keys/$key.keystore
	keytool -genkey -v -keystore keys/$key.keystore -alias $key -keyalg RSA -keysize 1024 -sigalg SHA1withRSA -validity 10000
	
	if [ $? -ne 0 ]; then
		echo "$red[?] Unable to create $key.keystore !! $reset"
		exit
	fi
else
	echo -e "$blue[*] Skipping key creation proccess$reset"
fi

echo -e "$green[+] Signing provided APK with $key.keystore file$reset"
jarsigner -keystore keys/$key.keystore $apk -sigalg SHA1withRSA -digestalg SHA1 $key

if [ $? -eq 0 ]; then
	echo -e "$green[+] Everything is good to go$reset"
else
	echo -e "$red[?] An error occured !!$reset"
fi


