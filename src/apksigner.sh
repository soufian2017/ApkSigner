#!/bin/bash

show_usage=0

case "$1" in -h | --help)
	show_usage=1
esac

if [ "$show_usage" -eq 1 ]; then
	echo "Usage : apksigner"
	echo "And fill the required spaces"
else
	echo "Entrer the KeyStore name : "
	read key
	echo "Entrer the alias : "
	read alia

	keytool -genkey -v -keystore /tmp/$key.keystore -alias $alia -keysize 2048 -validity 10000 
	# -importkeystore -srckeystore $alia.keystore -destkeystore $alia.keystore -deststoretype pkcs12

	echo
	echo $key.keystore creation SUCESSFUL
	echo
	echo "Entrer the path to you APK : "
	read apk

	jarsigner -digestalg SHA1 -keystore /tmp/$key.keystore $apk $alia
	rm /tmp/$key.keystore*
fi
	echo EXITED_SUCESSFULY
