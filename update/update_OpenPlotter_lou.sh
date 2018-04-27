#!/bin/bash
major=$1
version=$2
status=$3
repository=$4
branch="lou_config"
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
git https://github.com/$repository/openplotter.git openplotter_tmp
cd openplotter_tmp
git checkout $branch
cd ..
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
cd openplotter
chmod 755 openplotter
chmod 755 startup
chmod 755 keyword
echo
read -p "FINISHED, PRESS ENTER TO REBOOT SYSTEM."
shutdown -r now

