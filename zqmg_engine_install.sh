#!/bin/sh
echo "Installation of zqmg engine"

if test -d $HOME/zqmg
then
	echo "installation directory already exists"
	echo "break"
	exit 1
fi

echo "checking python3"
type python3 >/dev/null 2>/dev/null
if test $? = 1
then
	sudo apt-get install python3
	sudo apt-get install python3-setup-tools
	sudo apt-get install python3-pip
fi

echo "checking requirements"
sudo apt-get install python3-watchdog

type supervisorctl >/dev/null 2>/dev/null
if test $? = 1
then
	sudo apt-get install supervisor
fi

INSTALL_PATH=`pwd`

echo "Creating directories"
mkdir zqmg
mkdir zqmg/env
cd zqmg

echo "Create python environment"
python3 -m venv ./env

echo "Install additional python components"
./env/bin/pip3 install watchdog

echo "cloning engine from github"
git clone https://github.com/zapplv12/zqmg_engine

echo "making directories"
mkdir ./zqmg_engine/pid
chmod 777 ./zqmg_engine/pid

mkdir ./zqmg_engine/logs
chmod 777 ./zqmg_engine/logs

mkdir ./zqmg_engine/db
chmod 777 ./zqmg_engine/db

mkdir ./zqmg_engine/tmp
chmod 777 ./zqmg_engine/tmp

mkdir ./zqmg_engine/storage
chmod 777 ./zqmg_engine/storage

mkdir ./zqmg_engine/ev
chmod 777 ./zqmg_engine/ev

mkdir ./zqmg_engine/ev/responses
chmod 777 ./zqmg_engine/ev/responses


mkdir ./zqmg_engine/config/seq
chmod 777 ./zqmg_engine/config/seq

mkdir ./zqmg_engine/config/zqmg
chmod 777 ./zqmg_engine/config/zqmg

mkdir ./zqmg_engine/config/services
chmod 777 ./zqmg_engine/config/services

mkdir ./zqmg_engine/config/supervisor
chmod 777 ./zqmg_engine/config/supervisor


echo -n "Enter url of your admin system: "
read URL

echo -n "Enter security token of your admin system: "
read TOKEN

echo -n "Enter passphrase of your admin system: "
read PASSPHRASE

echo "preparing configuration file"

DATE=`date`

echo "{" >./zqmg_engine/config/zqmg_common.json
echo "\"versionecho \" : \"1.00\"," >>./zqmg_engine/config/zqmg_common.json 
echo "\"processing_groups\" : []," >>./zqmg_engine/config/zqmg_common.json
echo "\"updated\" : \"$DATE\"," >>./zqmg_engine/config/zqmg_common.json
echo "\"admin_url\" : \"$URL\"," >>./zqmg_engine/config/zqmg_common.json
echo "\"admin_Debug_url\" : \"$URL:8000\"," >>./zqmg_engine/config/zqmg_common.json
echo "\"sync_token\" : \"$TOKEN\"," >>./zqmg_engine/config/zqmg_common.json
echo "\"sync_info\" : \"$PASSPHRASE\"," >>./zqmg_engine/config/zqmg_common.json
echo "\"sync_page_size\" : 100," >>./zqmg_engine/config/zqmg_common.json
echo "\"sync_timer\" : 1.5," >>./zqmg_engine/config/zqmg_common.json
echo "\"response_timer\" : 1.5," >>./zqmg_engine/config/zqmg_common.json
echo "\"scheduler_timer\" : 0.5," >>./zqmg_engine/config/zqmg_common.json
echo "\"supervisor_url\" : \"http://localhost:9001/RPC2\"" >>./zqmg_engine/config/zqmg_common.json
echo "}" >>./zqmg_engine/config/zqmg_common.json

echo "preparing supervisor base configuration"
sudo service supervisor stop
sudo rm /etc/supervisor/conf.d/zqmg_base.conf

zqmghome=`pwd`/zqmg_engine
sed -e "s@__ZQMG_HOME__@$zqmghome@g" ./zqmg_engine/templates/zqmg_base.tpl >./zqmg_engine/config/supervisor/zqmg_base.conf
sudo ln -s $zqmghome/config/supervisor/zqmg_base.conf /etc/supervisor/conf.d/zqmg_base.conf

echo "relocation of programs"
cat ./zqmg_engine/bin/tools/zqmgcmd | sed -e "s@__INSTALL_PATH__@$INSTALL_PATH@g" > ./zqmg_engine/bin/zqmgcmd
cat ./zqmg_engine/bin/tools/zqmgsql | sed -e "s@__INSTALL_PATH__@$INSTALL_PATH@g" > ./zqmg_engine/bin/zqmgsql
cat ./zqmg_engine/bin/tools/zqmghttpd | sed -e "s@__INSTALL_PATH__@$INSTALL_PATH@g" > ./zqmg_engine/bin/zqmghttpd

chmod +x ./zqmg_engine/bin/zqmgcmd
chmod +x ./zqmg_engine/bin/zqmgsql
chmod +x ./zqmg_engine/bin/zqmghttpd

sudo cp ./zqmg_engine/bin/zqmgcmd /usr/local/bin
sudo cp ./zqmg_engine/bin/zqmgsql /usr/local/bin
sudo cp ./zqmg_engine/bin/zqmghttpd /usr/local/bin

if test "$ZQMG_HOME" = ""
then
	if test -f $HOME/.profile
	then
		echo "PATH=$zqmghome/bin:\$PATH">>$HOME/.profile
		echo "export PATH" >>$HOME/.profile
	fi
fi
. $HOME/.profile

echo "starting base services"
sudo service supervisor start

echo "end of installation"
