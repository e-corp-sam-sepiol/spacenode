# Raspberry Pi Zero Wireless
<p align="center">
  <img src="https://i.imgur.com/9T0gKr7.png">
</p>

#### Why a Raspberry Pi Zero Wireless?
>Raspberry Pi Zero W is an inexpensive computing hardware platform that generates little heat, draws little power, and can run silently 24 hours a day without having to think about it.

#### Raspberry Pi Zero Wireless Specifications
* 1GHz, single-core CPU
* 512MB RAM
* 802.11 b/g/n wireless LAN
* Bluetooth 4.1

#### Power Consumption
|  Pi Model |                       Pi State                       | Power Consumption |
|:---------:|:----------------------------------------------------:|:-----------------:|
|     A+    | Idle, HDMI disabled, LED disabled, USB WiFi adapter  |    160 mA (0.8W   |
|     B+    |  Idle, HDMI disabled, LED disabled, USB WiFi adapter |   220 mA (1.1W)   |
| model 2 B |  Idle, HDMI disabled, LED disabled, USB WiFi adapter |   240 mA (1.2W)   |
|    Zero   |  Idle, HDMI disabled, LED disabled, USB WiFi adapter |   120 mA (0.7W)   |

#### Parts list  
|                          Parts                         |    Price   |                                       Link                                       |
|:------------------------------------------------------:|:----------:|:--------------------------------------------------------------------------------:|
|            CanaKit Pi Zero W 8GB Starter Kit           | $29.99 USD |                   https://www.amazon.com/gp/product/B06XJQV162/                  |
Seagate Expansion 8TB Desktop External Hard Drive USB 3.0                  | $139.00 USD | https://www.amazon.com/Seagate-Expansion-Desktop-External-STEB8000100/dp/B01HAPGEIE/           |
| `OPTIONAL:` Zebra Zero Black Ice Heatsink Case by C4Labs |  $6.95 USD |                   https://www.amazon.com/gp/product/B01HP636I4/                  |

**Please use an External Hard Drive in an enclosure with it's own power source, avoid External Hard Drives that are USB powered. This is important for power stability of your Raspberry Pi Zero Wireless.**

## Installing Raspbian Stretch Lite

`NOTE:` The steps provided below produce a “headless” server... meaning we will not be using a GUI to configure Hyperspace or check to see how things are running. In fact, once the server is set up, you will only interact with it using command line calls over `SSH`. The idea is to have this hosting node be simple, low-power, with optimized memory usage and something that “just runs” in your basement, closet, etc.

>Raspbian is a free operating system based on Debian, optimised for the Raspberry Pi hardware. Raspbian comes with over 35,000 packages: precompiled software bundled in a nice format for easy installation on your Raspberry Pi. `https://www.raspberrypi.org/documentation/raspbian/`

Download the latest stable version of [Raspbian Stretch Lite](https://www.raspberrypi.org/downloads/raspbian/).

#### Install Raspbian Stretch Lite to your microSD card
* [Installing Operating System Images Using Windows](https://www.raspberrypi.org/documentation/installation/installing-images/windows.md)
* [Installing Operating System Images Using Mac OS](https://www.raspberrypi.org/documentation/installation/installing-images/mac.md)
* [Installing Operating System Images Using Linux](https://www.raspberrypi.org/documentation/installation/installing-images/linux.md)

#### Enable SSH Server on first Boot
* [Step 3. Enable SSH by placing a file named "ssh" (without any extension) onto the boot partition of the microSD card](https://hackernoon.com/raspberry-pi-headless-install-462ccabd75d0) 

#### Enable Wireless Connection on first Boot
Create a new text file named `wpa_supplicant.conf` on the boot partition of the microSD card, this will hold the network information.

Edit the newly created file, adjusting for the name of your country code, network name and network password

```
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="NETWORK-NAME"
    psk="NETWORK-PASSWORD"
}
```
Please safely remove the USB Card Reader / MicroSD card as to ensure the data is not corrupted

### Inital Setup of Raspberry Pi Zero Wireless
#### Boot your Raspberry Pi
Open a web browser page and navigate to your router page and identify the IP address of the freshly powered on Raspberry Pi. In my case the IP address is `192.168.1.10`, please make note of your Raspberry Pi's IP address as we will need to use it to login via `SSH`.

**I like to access my Raspberry Pi through an `SSH` session on my Windows PC using `Git Bash` which is included in the Windows [download](https://git-scm.com/downloads) of `Git`. Git Bash is my preferred means of using `SSH` on Windows.** 

**_This guide assumes the user is using `Git Bash`_**  
`Git download link: https://git-scm.com/downloads`  

#### Log into your Raspberry Pi Zero Wireless
Open `Git Bash` or your default terminal application and enter `SSH`, the `IP` address of your Pi and `-l pi` for it's login name
```
ssh 192.168.1.10 -l pi
```
```
$ ssh -h
ssh: unknown option -- h
usage: ssh [-46AaCfGgKkMNnqsTtVvXxYy] [-b bind_address] [-c cipher_spec]
           [-D [bind_address:]port] [-E log_file] [-e escape_char]
           [-F configfile] [-I pkcs11] [-i identity_file]
           [-J [user@]host[:port]] [-L address] [-l login_name] [-m mac_spec]
           [-O ctl_cmd] [-o option] [-p port] [-Q query_option] [-R address]
           [-S ctl_path] [-W host:port] [-w local_tun[:remote_tun]]
           [user@]hostname [command]
```

#### Download, install system updates and clean up
```
sudo apt-get update ; sudo apt-get upgrade -y ; sudo apt-get autoremove -y ; sudo apt-get autoclean -y
```

#### Download and install recommended packages
* [ufw](https://help.ubuntu.com/community/UFW)
> `ufw` provides a user friendly way to create an IPv4 or IPv6 host-based firewall
* [Fail2Ban](https://www.fail2ban.org/wiki/index.php/Main_Page)
> Fail2ban is a daemon that can be run on your server to dynamically block clients that fail to authenticate correctly with your services repeatedly. This can help mitigate the affect of brute force attacks and illegitimate users of your services like `SSH`.
* Git
```
sudo apt-get install ufw fail2ban git -y
```

#### Configure your Raspberry Pi Zero Wireless
```
pi@raspberrypi:~ $ sudo raspi-config
```
```
2.) [1] Change User Password        # change password for current user
3.) [2] Network Options               # configure network settings
	> [N1] Change Hostname                # set the visible hostname for this Pi on a network
4.) [7] Advanced Options     
	> [A1] Expand Filesystem                # expand filesystem 
```
`<Finish>` and choose to reboot the Raspberry Pi.

Wait a minute, then attempt to log back into your Raspberry Pi Zero Wireless via `SSH`
```
ssh 192.168.1.10 -l pi
```
Set a static IP address for your Raspberry Pi Zero Wireless. You don't want the `IP` address of your Hyperspace host to change unknowingly, and no longer have a reachable host

#### Wireless Interface
```
sudo nano /etc/network/interfaces
```
Configure your `/etc/network/interfaces` file to reflect the `IP` address of your Raspberry Pi, the `netmask` and the `gateway` (the `IP` of your router) so that if appears similar to the example below. Your file will likely be empty when you first open it
```
# interfaces(5) file used by ifup(8) and ifdown(8)

# Please note that this file is written to be used with dhcpcd
# For static IP, consult /etc/dhcpcd.conf and 'man dhcpcd.conf'

# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback
iface eth0 inet dhcp
allow-hotplug wlan0

iface wlan0 inet manual
wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf

iface home inet static
address 192.168.1.10
netmask 255.255.255.0
gateway 192.168.1.1

iface default inet dhcp
```
`CTRL+X to save/close document` 

#### Configure firewall `ufw`
Automatically deny incoming traffic
```
sudo ufw default deny incoming
```
Automatically allow outgoing traffic
```
sudo ufw default allow outgoing
```
Grab your `IP` range
```
ip -o -f inet addr show | awk '/scope global/{sub(/[^.]+\//,"0/",$4);print $4}' | awk 'NR==1{print $1}'
```
This firewall rule prevents any host outside of your `LAN` to `SSH` into your Raspberry Pi Zero Wireless. Replace `192.168.1.0/24` with the `IP` range given to you by the command above. `192.168.1.0/24` happens to be my `IP` range, yours may be different  
```
sudo ufw allow from 192.168.1.0/24 to any port 22 comment 'allow SSH from local LAN'
```
Open a port for Hyperspace Hosting
```
sudo ufw allow 5582 comment 'allow hyperspace hosting'
```
Enable the firewall settings
```
sudo ufw --force enable
```
Install `ufw` as a service 
```
sudo systemctl enable ufw
```
Check firewall status
```
sudo ufw status
```
```
Status: active

To                         Action      From
--                         ------      ----
22                         ALLOW       192.168.1.0/24             # allow SSH from local LAN
5582                       ALLOW       Anywhere                   # allow hyperspace hosting
5582 (v6)                  ALLOW       Anywhere (v6)              # allow hyperspace hosting
```

#### Configure External Hard Drive
If you have not plugged in your External Hard Drive to power and then into your Raspberry Pi Zero Wireless's micro USB interface via OTG cable, this is the time to do so. Please use an External Hard Drive in an enclosure with it's own power source, avoid External Hard Drives that are USB powered. This is important for power stability of your Raspberry Pi Zero Wireless.

In this example, a Seagate Expansion 8TB Desktop External Hard Drive USB 3.0 is being used  
```
sudo lsblk
```
```
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda           8:0    0  7.3T  0 disk
├─sda1        8:1    0  128M  0 part
└─sda2        8:2    0  7.3T  0 part
mmcblk0     179:0    0 59.5G  0 disk
├─mmcblk0p1 179:1    0 43.2M  0 part /boot
└─mmcblk0p2 179:2    0 59.4G  0 part /
```

-----------------------------------------

`sda` is the name of the External Hard Drive in this example  

Remember to change your commands to reflect the name of your External Hard Drive  

`sda1` and `sda2` are the two partitions that exist on the 8TB External Hard Drive  

The hard drive must have it's partitions consolidated into a single partition, as well as creating a new filesystem native to Linux for the External Hard Drive (`ext4`)  

`NOTE` If you only find a single partition such as `sda1`, and no other partitions such as `sda2`, you can simply use this command and skip to the **Configure mounting of External Hard Drive** section  
```
sudo mkfs.ext4 /dev/sda1 -L storage
```

-----------------------------------------

First we must remove the two partitions from this drive, and then create a partition we can use for hosting
```
sudo mkfs.ext4 /dev/sda -l untitled
mke2fs 1.43.4 (31-Jan-2017)
Found a gpt partition table in /dev/sda
Proceed anyway? (y,N) y
```
We can check to ensure our changes were made
```
sudo lsblk
```
```
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda           8:0    0  7.3T  0 disk
mmcblk0     179:0    0 59.5G  0 disk
├─mmcblk0p1 179:1    0 43.2M  0 part /boot
└─mmcblk0p2 179:2    0 59.4G  0 part /
```
Great! Now we can create our partition for hosting

```
sudo parted /dev/sda
```
Create a new GPT disklabel, i.e partition table
```
(parted) mklabel gpt
```
Set the default unit to TB
```
(parted) unit TB
```
Create a partition that matches the size of your External Hard Drive
```
(parted) mkpart primary 0.00TB 7.30TB
```
Print the current partitions
```
(parted) print
```
```
Model: Seagate Expansion Desk (scsi)
Disk /dev/sda: 8002GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name     Flags
 1      1049kB  7300GB  7300GB               primary
```
Success! There is a single partition on the External Hard Drive, let's format it. But first, exit `parted`
```
(parted) quit
```
Check the current block devices, and their partition numbers
```
sudo lsblk
```
```
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda           8:0    0  7.3T  0 disk
└─sda1        8:1    0  6.7T  0 part
mmcblk0     179:0    0 59.5G  0 disk
├─mmcblk0p1 179:1    0 43.2M  0 part /boot
└─mmcblk0p2 179:2    0 59.4G  0 part /
```
Create a new `ext4` filesystem on `sda1`
```
sudo mkfs.ext4 /dev/sda1 -L storage
```
```
mke2fs 1.43.4 (31-Jan-2017)
Creating filesystem with 1782226432 4k blocks and 222781440 inodes
Filesystem UUID: fc1c8015-be6d-484a-8e24-3fd535d8f283
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
        102400000, 214990848, 512000000, 550731776, 644972544

Allocating group tables: done
Writing inode tables: done
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: done
```

#### Configure mounting of External Hard Drive
```
sudo blkid
```
Note the `UUID` of the External Hard Drive = `fc1c8015-be6d-484a-8e24-3fd535d8f283`
```
/dev/mmcblk0p1: LABEL="boot" UUID="3725-1C05" TYPE="vfat" PARTUUID="cc9730ad-01"
/dev/mmcblk0p2: LABEL="rootfs" UUID="fd695ef5-f047-44bd-b159-2a78c53af20a" TYPE="ext4" PARTUUID="cc9730ad-02"
/dev/mmcblk0: PTUUID="cc9730ad" PTTYPE="dos"
/dev/sda1: LABEL="storage" UUID="fc1c8015-be6d-484a-8e24-3fd535d8f283" TYPE="ext4" PARTLABEL="primary" PARTUUID="c613bd10-2f70-49a4-966d-4faa8bd140f7"
```
Configure the `/etc/fstab` file for auto-mounting on boot
```
sudo nano /etc/fstab
```
```
proc            /proc           proc    defaults          0       0
PARTUUID=cc9730ad-01  /boot           vfat    defaults          0       2
PARTUUID=cc9730ad-02  /               ext4    defaults,noatime  0       1
# a swapfile is not a swap partition, no line here
#   use  dphys-swapfile swap[on|off]  for that
```
Go to the bottom of the file and create a new line, and enter this information so it reflects your External Hard Drive's `UUID` rather than the one being used in this guide. `UUID` are unique, if you format the drive the `UUID` will change. 

`NOTE` Do not literally type `[TAB]` between each option, the `[TAB]` represents the act of the user hitting their tab key
```
proc            /proc           proc    defaults          0       0
PARTUUID=cc9730ad-01  /boot           vfat    defaults          0       2
PARTUUID=cc9730ad-02  /               ext4    defaults,noatime  0       1
# a swapfile is not a swap partition, no line here
#   use  dphys-swapfile swap[on|off]  for that

UUID=fc1c8015-be6d-484a-8e24-3fd535d8f283[TAB]/home/pi/storage[TAB]ext4[TAB]defaults,noatime[TAB]0[TAB]0
```
`CTRL+X to save/close document`

#### Create the mount point for the External Hard Drive, and mount the Hard Drive
```
mkdir storage
```
```
sudo mount -a
```
Now modify the permissions of the `storage` folder to be accessable by every user
```
sudo chmod 777 storage
```

### Installing `golang 1.10`
Download `golang` for `ARM` CPU's 
```
curl -L -O https://dl.google.com/go/go1.10.3.linux-armv6l.tar.gz
```
Decompress the archive into the `/usr/local` folder
```
sudo tar -C /usr/local -xzf go1.10.3.linux-armv6l.tar.gz
```
Create a directory for your `$GOPATH`
```
mkdir go
```
Export environment variables to `.bashrc` and the current shell
```
echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/pi/.bashrc
```
```
echo 'export GOPATH=$HOME/go' >> /home/pi/.bashrc
```
```
export GOPATH=$HOME/go  
```
```
export PATH=$PATH:/usr/local/go/bin
```
Check the version of `golang` installed
```
go version
```
`go version go1.10.3 linux/arm`  

### Download and compile Hyperspace from source
```
go get -u github.com/HyperspaceApp/Hyperspace/...
```
Change directories to the `$GOPATH/.../Hyperspace` folder
```
cd go/src/github.com/HyperspaceApp/Hyperspace/
```
Pull the latest code for full nodes
```
git pull origin 0.2.2
```
```
From https://github.com/HyperspaceApp/Hyperspace
 * branch                0.2.2     -> FETCH_HEAD
Already up-to-date.
```
Build the new binaries
```
make release
```
Go back to your home directory, and then into your `$GOPATH/bin` to initalize Hyperspace
```
cd ; cd go/bin/
```

### Starting Hyperspace
`NOTE` If you intend on running multiple hosts, you will need to use the `--host-addr :5583`... `:5584`, `:5885`, etc. Hyperspace's hosting port defaults to `:5882`. If this is your first host, you don't need to worry.

Start Hyperspace Daemon and send to the background
```
~/go/bin $ ./hsd &
```
```
Hyperspace Daemon v0.2.0
Git Revision 76f89464b
Loading...
(0/6) Loading hsd...
(1/6) Loading gateway...
(2/6) Loading consensus...
(3/6) Loading transaction pool...
(4/6) Loading wallet...
(5/6) Loading host...
(6/6) Loading renter...
Finished loading in 1.7456555150000002 seconds
```
`[ENTER]` to get your command prompt back

It's important to note that the blockchain will take some time to sync, I recommend allowing the Raspberry Pi Zero Wireless some time to sync before attempting to scan the blockchain for `tx`'s when you load a wallet. The blockchain size is about `~300MB` on `10/5/2018`. 

### Configure Hyperspace

When you are ready to create a new wallet for your Raspberry Pi Zero Wireless make sure that you are in your `$GOPATH/bin/`
```
cd ; cd go/bin/
```
Initalize a new wallet for Hyperspace
```
./hsc wallet init
```
`PLEASE TAKE NOTE OF THE SEED GIVEN TO YOU, THIS WILL ENABLE YOU TO RESTORE THIS WALLET IF YOU NEED TO`  

Next unlock the newly created wallet. **Use your seed as the password to unlock the wallet for the first time.**
```
./hsc wallet unlock
```

Change the wallet password
```
./hsc wallet change-password
```

Generate a new recieve address for your Hyperspace wallet
```
./hsc wallet new-address
```

-----------------------------------------

**Send `2,000` `SPACE` to the address created, this will send `2,000` `SPACE` to your Raspberry Pi's wallet. This is the amount needed to host on Hyperspace. If you are in need of `SPACE` to host, please contact @Sam Sepiol#3396 @mark#1011 or @Yanlin#8561 on the Hyperspace Discord.**  

**You will need to wait until the `2,000` `SPACE` balance is confirmed on your Raspberry Pi wallet before you can start hosting, the average time it takes to do this is about 10 minutes, however you may find blocks may take longer to find some times.** 

-----------------------------------------

You have the option to configure your hosting options shown below
* `mindownloadbandwidthprice` = The price that a renter has to pay when downloading data from the host.
* `minstorageprice` = The price that a renter has to pay to store files with the host.
* `minuploadbandwidthprice` = The price that a renter has to pay to store files with the host.
* `mincontractprice` = The price that a renter has to pay to create a contract with the host. The payment is intended to cover transaction fees for the file contract revision and the storage proof that the host will be submitting to the blockchain.

#### View Hyperspace Hosting Configuration Help
```
./hsc host config -h
```
#### Example Commands
Set the download bandwidth price to `200` `SPACE` per/TB
```
./hsc host config mindownloadbandwidthprice 200S
```
Set the upload bandwidth price to `200` `SPACE` per/TB
```
./hsc host config minuploadbandwidthprice 200S
```
Set the storage price to `100 SPACE`  
```
./hsc host config minstorageprice 100S
```
Set the contract price to `150 mS`
```
./hsc host config mincontractprice 150mS
```

**Once you have configured your Hyperspace hosting options and are ready to move on to dedicating storage space for hosting...**

Check the available space on the mounted External Hard Drive
```
df -h
```
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/root        59G  2.0G   55G   4% /
devtmpfs        460M     0  460M   0% /dev
tmpfs           464M     0  464M   0% /dev/shm
tmpfs           464M   30M  435M   7% /run
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
tmpfs           464M     0  464M   0% /sys/fs/cgroup
/dev/mmcblk0p1   43M   22M   21M  52% /boot
tmpfs            93M     0   93M   0% /run/user/1000
/dev/sda1       6.6T   89M  6.3T   1% /home/pi/storage
```
Add the location `/home/pi/storage` to Hyperspace hosting with an allocated size that reflects the size available on your External Hard Drive
```
./hsc host folder add /home/pi/storage 6.3TB
```
`Added folder /home/pi/storage`  

Check your hosting settings
```
./hsc host
```
```
Host info:
        Connectability Status: Host is not connectable (re-checks every few minutes).

        Storage:      6.2999 TB (0 B used)
        Price:        100 S / TB / Month
        Max Duration: 25 Weeks

        Accepting Contracts:  No
        Anticipated Revenue:  0 H
        Locked Collateral:    0 H
        Revenue:              0 H

Warning:
        Your wallet is locked. You must unlock your wallet for the host to function properly.

Storage Folders:
    Used    Capacity     % Used    Path
    0 B     6.2999 TB    0.00      /home/pi/storage
```

### Port Forward port `5582` on your Raspberry Pi Zero Wireless
Access your router's web page through a web browser, the `IP` address is commonly similar to `192.168.1.1` for most home routers

You can find the address of your router by using the following command
```
ip route | grep default
```
`default via 192.168.1.1 dev eth0 src 192.168.1.10 metric 202`  

Access the port forwarding section of your router's firmware, create a new port forwarding rule for the `IP` address that belongs to your Raspberry Pi which you set as `static` before. Make sure port `5582 TCP/UDP` is forwarded, saved and applied. 

Once your port forwarding has been configured you can use tools like [CanYouSeeMe.org](http://canyouseeme.org/) and check for port `5582`. If your port forwarding has been done correctly, the CanYouSeeMe service should return `Success: I can see your service on XX.XXX.XX.XX on port (5582)`.

### `OPTIONAL:` Setup DynamicDNS (no-ip.com, etc. for hosting)
Many modern routers contain the ability to setup a Dynamic DNS in the router firmware page, allowing you to resolve your `IP` address to a string of characters. 

<p align="center">
  <img src="https://i.imgur.com/tn2rLS3.png">
</p>

-----------------------------------------

### Enable Hyperspace Wallet Auto-Unlock
To enable auto-unlocking of your Hyperspace wallet you must set the `environment` variable `HYPERSPACE_WALLET_PASSWORD` for the current shell, and then ensure the `.bashrc` file also sets the `enviornment` variable for future shell sessions.  

```
export HYPERSPACE_WALLET_PASSWORD=yoursecurehyperspacewalletpassword
echo 'export HYPERSPACE_WALLET_PASSWORD=yoursecurehyperspacewalletpassword' >> /home/pi/.bashrc
```

### Configure `crontab` for `hsd` launch on reboot, and wallet auto-unlocking

This `cronjob` sources the users `.profile` which contains saved `env` variables, changes directory to where the `hsd` binary resides, executes `hsd` and backgrounds the process. The wallet finds the `HYPERSPACE_WALLET_PASSWORD` `env` variable and automatically unlocks the wallet. 

__Edit your `crontab` file, add the bottom line to your `crontab` file.__

`crontab -u pi -e`  
```
@reboot $HOME/.profile; cd /home/pi/go/bin/ ; ./hsd &
```

__If you are running multiple hosts, you will have to specifiy a secondary port number to access the host from.__  
__`--host-addr :5583` replace with your desired port.__
```
@reboot $HOME/.profile; cd /home/pi/go/bin/ ; ./hsd --host-addr :5583 &
```

-----------------------------------------

### Start Hosting
To begin hosting you need to announce your host to the network, which it will then begin forming contracts with renters and automatically locking collateral and managing contracts in the background

Before announcing your host to the network, you have to ensure your wallet is `unlocked` and holds a balance of `2,000` `SPACE` or more to host
```
./hsc wallet
```
```
Wallet status:
Encrypted, Unlocked
Height:              10475
Confirmed Balance:   2 KS
Unconfirmed Delta:  +0 H
Exact:               2000000000000000000000000000 H

Estimated Fee:       30 mS / KB
```

-----------------------------------------

**`OPTION 1:` Announce with a Dynamic DNS name (from your no-ip.com account, etc)**
```
./hsc host announce ecorphosting.ddns.net:5582
```
```
Host announcement submitted to network.
The host has also been configured to accept contracts.
To revert this, run:
        hsc host config acceptingcontracts false
```

-----------------------------------------

**`OPTION 2:` Announce with your `WAN` `IP` address**
* Grab your `WAN` `IP` address
```
curl ipinfo.io/ip
```
* Announce using your `IP` address displayed from the `curl` command
```
./hsc host announce XX.XXX.XX.XX:5582
```
```
Host announcement submitted to network.
The host has also been configured to accept contracts.
To revert this, run:
        hsc host config acceptingcontracts false
```

-----------------------------------------

#### Check hosting status
This command should reflect a working host after about a half an hour if you have properly port forwarded, using canyouseeme.org to confirm the port has been opened  
```
./hsc host
```
```
Host info:
        Connectability Status: Host appears to be working.

        Storage:      6.2999 TB (0 B used)
        Price:        100 S / TB / Month
        Max Duration: 25 Weeks

        Accepting Contracts:  Yes
        Anticipated Revenue:  300 mS
        Locked Collateral:    12.97 S
        Revenue:              0 H

Storage Folders:
    Used    Capacity     % Used    Path
    0 B     6.2999 TB    0.00      /home/pi/storage
```

### You're hosting on Hyperspace!

**When you want to close your `SSH` session with your Pi, simply type `exit` and hit `enter`. This will ensure the backgrounded `hsd` process is not halted on disconnect.**  

### Donations
If you found my guide helpful and want to donate...  
<p align="center">
  <img src="https://i.imgur.com/UVOuTsy.png">
</p>

Hyperspace Address   
```
SPACE: 543a9afc652bf892655db2f622505ab92be2a5ce251646367964c9ef4fdaf24c240fffb5f4e1
```

-----------------------------------------
# Updating Hyperspace

Change directories to the Hyperspace repository found in your `$GOPATH/src` folder. The compiled binaries are stored in the `$GOPATH/bin` folder  
```
cd ; cd go/src/github.com/HyperspaceApp/Hyperspace/
```
Run `git pull origin 0.2.2` to pull the latest full node code.
```
git pull origin 0.2.2
```
Use `make release` to build the new binaries if new changes are pulled.
```
make release
```

-----------------------------------------
# Resources

### [Hyperspace Guide / FAQ / App](https://hyperspace.guide/faq/hyperspace_app)
* [Should I back anything up to make sure I don't lose my wallet or other important data in Hyperspace?](https://hyperspace.guide/faq/hyperspace_app#back_up_data)
* [Where are Hyperspace's internal data files stored?](https://hyperspace.guide/faq/hyperspace_app#internal_data_files)
### [Hyperspace Guide / FAQ / Hosting](https://hyperspace.guide/faq/hosting)
* [What if I can't stay online as a host? What if it's not my fault (hardware failure, power outage, etc)?](https://hyperspace.guide/faq/hosting#uptime_responsibility)
* [Can I keep my wallet unlocked or unlock it automatically? Why would I want to do that?](https://hyperspace.guide/faq/hosting#auto_start_and_wallet_auto_unlock)
* [Hyperspace says "Host Unreachable" a few minutes after it starts.](https://hyperspace.guide/faq/hosting#host_unreachable)
* [What sort of income can I expect when hosting?](https://hyperspace.guide/faq/hosting#income)
* [Why do I see a bunch of small (or sometimes large) transactions taken from my wallet while hosting?](https://hyperspace.guide/faq/hosting#small_transactions)
### [Hyperspace Guide / FAQ / Renting](https://hyperspace.guide/faq/renting)
### [Sia Wiki.Tech](https://siawiki.tech/index)
* [What is Hyperspace?](https://github.com/e-corp-sam-sepiol/spacenode/wiki/What-is-Hyperspace%3F)
* [Introduction to File Contracts](https://github.com/e-corp-sam-sepiol/spacenode/wiki/Introduction-to-File-Contracts)
* `TECHNICAL` [Contracts](https://github.com/e-corp-sam-sepiol/spacenode/wiki/Contracts)
* [The Hyperspace Daemon](https://github.com/e-corp-sam-sepiol/spacenode/wiki/The-Hyperspace-Daemon)
* [Hosting](https://github.com/e-corp-sam-sepiol/spacenode/wiki/Hosting)
* [Host Scoring](https://github.com/e-corp-sam-sepiol/spacenode/wiki/Host-Scoring)
* [Security of Hosts](https://github.com/e-corp-sam-sepiol/spacenode/wiki/Security-of-Hosts)
* [Renting](https://github.com/e-corp-sam-sepiol/spacenode/wiki/Renting)
