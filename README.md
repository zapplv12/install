# install
Installation scripts

## MDS Frappe Framework (bench + frappe)

### Add Base User

`adduser [mdsbase-user]`
  
 `usermod -aG sudo [mdsbase-user]`

### update apt repository
 `sudo apt-get update`

### Install pip
`sudo apt-get install python-pip`

### Install pip3
`sudo apt-get install python3-pip`

### Download installation script

`wget https://raw.githubusercontent.com/zapplv12/install/master/mds_bench_install.py`

### Start installation
`sudo python3 ./mds_bench_install.py --develop --user [mdsbase-user]`

### Site anlegen
`cd /mdsbase-user/frappe-bench`
`bench new-site your-site-name`

### Ressourcen erstellen und linken
`cd /mdsbase-user/frappe-bench`
`bench build`

### Produktionsmodus aktivieren
`cd /mdsbase-user/frappe-bench`
`sudo bench setup production mdsbase-user`

### Anmeldung und Initialisierung
`Browser starten`
`http://servername`
`Mit "Administrator" und dem eingegebenen Kennwort anmelden`
`Einstellungen durchführen`

VIEL SPASS!


## ZQMG Engine

### Download installation script

`wget https://raw.githubusercontent.com/zapplv12/install/master/zqmg_engine_install.sh`

### Change access rights

`chmod +x zqmg_engine_install.sh`

### Start installation

`./zqmg_engine_install.sh`
