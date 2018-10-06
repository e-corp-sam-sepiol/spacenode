<p align="center">
  <img src="https://i.imgur.com/u02fEDN.png" width="300" height="300" />
</p>

# Raspberry Pi 3
<p align="center">
  <img src="https://i.imgur.com/zgx4uiu.jpg">
</p>

#### Why a Raspberry Pi?
>Raspberry Pi is an inexpensive computing hardware platform that generates little heat, draws little power, and can run silently 24 hours a day without having to think about it. [1]

#### Raspberry Pi 3 B+ Specifications
* Broadcom BCM2837B0, Cortex-A53 (ARMv8) 64-bit SoC @ 1.4GHz
* 1GB LPDDR2 SDRAM
* 2.4GHz and 5GHz IEEE 802.11.b/g/n/ac wireless LAN, Bluetooth 4.2, BLE
* Gigabit Ethernet over USB 2.0 (maximum throughput 300 Mbps)

#### Power Consumption
|  Pi Model  |             Pi State             | Power Consumption |
|:----------:|:--------------------------------:|:-----------------:|
| model 3 B+ |        HDMI off, LEDs off        |   350 mA (1.7W)   |
| model 3 B+ | HDMI off, LEDs off, onboard WiFi |   400 mA (2.0W)   |
|  model 3 B |        HDMI off, LEDs off        |   230 mA (1.2W)   |
|  model 3 B | HDMI off, LEDs off, onboard WiFi |   250 mA (1.2W)   |

### Parts List

| Parts                                                        | Price      | Link                                                                            |
|--------------------------------------------------------------|------------|---------------------------------------------------------------------------------|
| CanaKit Raspberry Pi 3 B+                                    | $49.99 USD | https://www.amazon.com/CanaKit-Raspberry-Power-Supply-Listed/dp/B07BC6WH7V/     |
| Sandisk Ultra 32GB Micro SDHC UHS-I Card      | $12.99 USD | https://www.amazon.com/Sandisk-Ultra-Micro-UHS-I-Adapter/dp/B073JWXGNT/      |
| Seagate Expansion 8TB Desktop External Hard Drive USB 3.0                  | $139.00 USD | https://www.amazon.com/Seagate-Expansion-Desktop-External-STEB8000100/dp/B01HAPGEIE/           |
Seagate Expansion 8TB Desktop External Hard Drive USB 3.0                  | $139.00 USD | https://www.amazon.com/Seagate-Expansion-Desktop-External-STEB8000100/dp/B01HAPGEIE/           |
Seagate Expansion 8TB Desktop External Hard Drive USB 3.0                  | $139.00 USD | https://www.amazon.com/Seagate-Expansion-Desktop-External-STEB8000100/dp/B01HAPGEIE/           |
Seagate Expansion 8TB Desktop External Hard Drive USB 3.0                  | $139.00 USD | https://www.amazon.com/Seagate-Expansion-Desktop-External-STEB8000100/dp/B01HAPGEIE/           |
Seagate Expansion 8TB Desktop External Hard Drive USB 3.0                  | $139.00 USD | https://www.amazon.com/Seagate-Expansion-Desktop-External-STEB8000100/dp/B01HAPGEIE/           |
| Transcend USB 3.0 SDHC / SDXC / microSDHC / SDXC Card Reader | $9.23 USD  | https://www.amazon.com/Transcend-microSDHC-Reader-TS-RDF5K-Black/dp/B009D79VH4/ |
| OPTIONAL: Zebra Black Ice Case for Raspberry Pi by C4Labs   | $14.95 USD | https://www.amazon.com/Zebra-Black-Case-Raspberry-C4labs/dp/B00M6G9YBM/         |

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

#### `Optional:` Enable Wireless Connection on first Boot
Create a new text file named `wpa_supplicant.conf` on the boot partition of the microSD card, this will hold the network information.

Edit the newly created file, adjusting for the name of your country code, network name and network password.

```
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="NETWORK-NAME"
    psk="NETWORK-PASSWORD"
}
```
Please safely remove the USB Card Reader / MicroSD card as to ensure the data is not corrupted.

### Inital Setup of Raspberry Pi
#### Boot your Raspberry Pi
Open a web browser page and navigate to your router page and identify the IP address of the freshly powered on Raspberry Pi. In my case the IP address is `192.168.1.11`, please make note of your Raspberry Pi's IP address as we will need to use it to login via `SSH`.

I like to access my Raspberry Pi through an `SSH` session on my Windows PC using `Git Bash` which is included in the Windows [download](https://git-scm.com/downloads) of `Git`.  
`Git download link: https://git-scm.com/downloads`  

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

#### Configure your Raspberry Pi
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


-----------------------------------------

# Raspberry Pi Zero Wireless
<p align="center">
  <img src="https://i.imgur.com/9T0gKr7.png">
</p>

#### Why a Raspberry Pi?
>Raspberry Pi Zero W is an inexpensive computing hardware platform that generates little heat, draws little power, and can run silently 24 hours a day without having to think about it. [1]

#### Raspberry Pi Zero W Specifications
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
|           Kingston Digital DataTraveler 16GB           |  $7.99 USD | https://www.amazon.com/Kingston-Digital-DataTraveler-DTSE9H-16GBZ/dp/B006W8U2WU/ |
Seagate Expansion 8TB Desktop External Hard Drive USB 3.0                  | $139.00 USD | https://www.amazon.com/Seagate-Expansion-Desktop-External-STEB8000100/dp/B01HAPGEIE/           |
Seagate Expansion 8TB Desktop External Hard Drive USB 3.0                  | $139.00 USD | https://www.amazon.com/Seagate-Expansion-Desktop-External-STEB8000100/dp/B01HAPGEIE/           |
Seagate Expansion 8TB Desktop External Hard Drive USB 3.0                  | $139.00 USD | https://www.amazon.com/Seagate-Expansion-Desktop-External-STEB8000100/dp/B01HAPGEIE/           |
Seagate Expansion 8TB Desktop External Hard Drive USB 3.0                  | $139.00 USD | https://www.amazon.com/Seagate-Expansion-Desktop-External-STEB8000100/dp/B01HAPGEIE/           |
| OPTIONAL: Zebra Zero Black Ice Heatsink Case by C4Labs |  $6.95 USD |                   https://www.amazon.com/gp/product/B01HP636I4/                  |

-----------------------------------------
# Updating Hyperspace


-----------------------------------------
# Resources
SlickDeals - Hard Drive Deals  
`https://slickdeals.net/forums/filtered/?f=9&intagid[]=300&icid=filtered_user`
