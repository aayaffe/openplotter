#!/bin/bash
set -x
major=$1
version=$2
status=$3
repository=$4
branch=$5
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
if [ -z $branch]; then
	if [ $status = "beta"]; then
		branch="beta"
	else
		branch = "master"
	fi
fi
if [ -z $op_folder ]; then
	op_folder="/.config"
fi


cd $HOME$op_folder

echo
echo "DOWNLOADING NEW OPENPLOTTER CODE..."
echo
rm -rf openplotter_tmp
git clone -b $branch https://github.com/$repository/openplotter.git openplotter_tmp
if [ $? -ne 0 ]; then
	echo
	read -p "#### ERROR. ABORTING, PRESS ENTER TO EXIT ####"
	exit 1
fi
echo
echo "CREATING OPENPLOTTER CODE BACKUP..."
echo
DIRDATE=`date +openplotter_bak_%Y_%m_%d:%H:%M:%S`
cp -a openplotter/ $DIRDATE/
cd $DIRDATE
find . -name "*.pyc" -type f -delete

cd $HOME$op_folder

source openplotter_tmp/update/update_settings.sh
if [ $major = 1 ]; then
	source openplotter_tmp/update/update_dependencies.sh
fi
echo
echo "COMPRESSING OPENPLOTTER CODE BACKUP INTO HOME..."
echo
tar cjf ~/$DIRDATE.tar.bz2 $DIRDATE
echo
echo "DELETING OLD OPENPLOTTER CODE FILES..."
echo
rm -rf openplotter
rm -rf $DIRDATE
mv openplotter_tmp openplotter
echo
read -p "FINISHED, PRESS ENTER TO REBOOT SYSTEM."
shutdown -r now

