#!/bin/bash
major=$1
version=$2
status=$3
repository=$4
op_folder=$(crudini --get ~/.openplotter/openplotter.conf GENERAL op_folder)
if [ -z $major ]; then
	major=1
fi
if [ -z $status ]; then
	status="beta"
fi
if [ -z $repository ]; then
	repository="openplotter"
fi
if [ -z $op_folder ]; then
	op_folder="/.config"
fi

cd $HOME$op_folder

echo
echo "DOWNLOADING NEW OPENPLOTTER CODE..."
echo
rm -rf openplotter_tmp
git clone https://github.com/$repository/openplotter.git openplotter_tmp
if [ $? -ne 0 ]; then
	echo
	read -p "#### ERROR. ABORTING, PRESS ENTER TO EXIT ####"
	exit 1
fi

echo
echo "DELETING OLD OPENPLOTTER CODE FILES..."
echo
rm -rf openplotter
mv openplotter_tmp openplotter
echo
read -p "FINISHED, PRESS ENTER TO REBOOT SYSTEM."
shutdown -r now

