#!/bin/sh
  
echo "deinstall of zqmg engine"
echo "stop services"
services=`ls $ZQMG_HOME/config/supervisor`
echo $services 
for name in $services
do
        groupname=`echo $name | sed -e "s/\.conf//"`
        sudo supervisorctl stop $groupname:*
done

echo "remove supervisor links"
for name in $services
do
        sudo rm /etc/supervisor/conf.d/$name
done

echo "reload supervisor config"
sudo supervisorctl reload

echo "remove command line program"
if test -f /usr/local/bin/zqmgcmd
then
        sudo rm /usr/local/bin/zqmgcmd
        sudo rm /usr/local/bin/zqmgsql
        sudo rm /usr/local/bin/zqmghttpd
fi

echo "remove programs"
cd $ZQMG_HOME
cd ..
cd ..
rm -rf zqmg

echo "deinstall done"
