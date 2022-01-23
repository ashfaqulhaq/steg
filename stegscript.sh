#!/bin/bash

filename="$1"

filetype=$(file $filename | grep "JPEG" | cut -d " " -f 2)

echo "$filetype"
flagsignature='IIUC'

install_stegsolve () {
	echo "Installing stegsolve"
	wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar && chmod +x stegsolve.jar && mkdir bin && mv stegsolve.jar bin/ && echo " Installed..."
	
}
install_exiftool () {
sudo apt install exiftool -y

}
install_zsteg () {

echo "Installing zteg"
sudo gem install zsteg

}

install_binwalk () {
sudo apt-get install binwalk
}

install_openstego () {

	wget https://github.com/syvaidya/openstego/releases/download/openstego-0.8.2/openstego_0.8.2-1_all.deb -O openstego.deb
	sudo apt install ./openstego.deb

}

install_steghide () {

sudo apt-get install steghide -y


}


analysing_process () {

if [ "$filetype" == "JPEG" ]
then
	echo "This is an jpeg image"
	echo " Analysing the image now..."
	echo "=================================================="
	strings $filename

	echo "--------------------------------------------------"

	strings $filename | grep $flagsignature

	echo "=================================================="
	echo "=================================================="

	echo "Running exiftool"
	echo "-------------------"
	exiftool $filename
	echo "=================================================="
	echo "running exiv2"
	
	exiv2 $filename
	
	echo "=================================================="

	echo "Running binwalk"
	echo "------------------"

	binwalk $filename
	echo " "

	read -p "Do you want run binwalk extract : (y/n) : " answer
	if [ $answer == 'y' ]
	then
		binwalk -e $filename 
	else
		continue
	fi

	echo "=================================================="

	echo "Running stegsolve"
	java -jar ./bin/stegsolve.jar &

	echo "=================================================="

	echo "Running steghide"
	read -p 'Steghide passphrase :' passphrase
	steghide extract -sf $filename -p passphrase

	echo "=================================================="

	echo "=================================================="


elif [ "$filetype" == "PNG" ]
then
	echo "this is a png file"
	echo "Analysing the image..."
	echo "=================================================="
	
	strings $filename

	echo "--------------------------------------------------"
	
	strings $filename | grep $flagsignature

	echo "=================================================="
	echo "=================================================="

	echo "Running exiftool"
	echo "-------------------"
	exiftool $filename

	echo "=================================================="

	echo "-------------------------------------------------"

	echo "Running zsteg"
	zsteg $filename 

	echo "see more options in zsteg -h"

	echo "=================================================="

	echo "Running openstego"

	openstego &

else
	echo "Works only for image files"
fi



}


acceptance='Y'
read -p "Do you have stegsolve-exiftool-binwalk-steghide-zsteg-openstego-stegcracker installed? Y/n :" acceptance

if [ $acceptance == 'N' ]
then
	install_stegsolve
	install_zsteg
	install_binwalk
	install_openstego
	install_steghide
	install_exiftool
	echo "Restart your terminal and the script if installation finished."
	
elif [ $acceptance == 'Y' ]
then
	analysing_process
fi




