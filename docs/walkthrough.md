# Raspberry Pi 

```
# update system and packages, install git and reboot
sudo apt-get update ; sudo apt-get upgrade -y ; sudo apt-get install git -y ; sudo reboot
```

```
# download go1.10.3 for arm
curl -L -O https://dl.google.com/go/go1.10.3.linux-armv6l.tar.gz

# decompress tar file in /usr/local
sudo tar -C /usr/local -xzf go1.10.3.linux-armv6l.tar.gz

# create a directory named go
cd ; mkdir go

# export env variables to .bashrc and current shell
echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/pi/.bashrc
echo 'export GOPATH=$HOME/go' >> /home/pi/.bashrc
export GOPATH=$HOME/go  
export PATH=$PATH:/usr/local/go/bin

# fetch golang version
go version
```

`go get -u github.com/HyperspaceApp/Hyperspace/...`

```
cd go/bin ; ./hsd --host-addr :5586 & 
# --host-addr flag is optional, used for multiple hosts on same LAN
```

`sudo apt-get install ufw`

```
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 192.168.1.0/24 to any port 22 comment 'allow SSH from local LAN'
sudo ufw allow 5586 comment 'allow hyperspace hosting'
sudo ufw --force enable
sudo systemctl enable ufw
sudo ufw status
```

```
mkdir storage
sudo lsblk
sudo mkfs.ext4 -F /dev/sda1 -L storage
sudo blkid
sudo nano /etc/fstab
UUID=0a338711-ac5a-497c-bfda-0b783c5c0629[TAB]/home/pi/storage[TAB]ext4[TAB]defaults,noatime[TAB]0[TAB]0
[ctrl+x to save]
sudo mount -a
sudo chmod 777 storage
```
