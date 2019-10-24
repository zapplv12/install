# install
Installation scripts

## MDS Frappe Framework (bench + frappe)

### Add Base User

  adduser [mdsbase-user]
  
  usermod -aG sudo [mdsbase-user]

### Download installation script

wget https://raw.githubusercontent.com/zapplv12/install/master/mds_bench_install.py

### Start installatiomn
sudo python3 ./mds_bench_install.py develop --user [mdsbase-user] 


## ZQMG Engine

### Download installation script

wget https://raw.githubusercontent.com/zapplv12/install/master/zqmg_engine_install.sh

### Change access rights

chmod +x zqmg_engine_install.sh

### Start installation

./zqmg_engine_install.sh
