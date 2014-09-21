---
layout: default
date: 2014-09-21 15:50:39
title: Upgrading debian kernel in stable release
---

During installing Debian Stable (Wheezy) on my brand new Acer Aspire E1-530 I met with error message about how debian could not find any network adapter at all. I've tried to run `lspci -nn` and saw both Ethernet and Wi-Fi adapters present, so it was obvious that this is fault of the old kernel image - new kernels have support for both wi-fi and Ethernet drivers. The straighforward solution to this would be building and installing a new kernel, but as this is the Debian and it's Stable, most optimal solution is to install kernel from backports. First to add backports repo for Wheezy: just add this line to the `/etc/apt/sources.list`:

	deb http://ftp.nl.debian.org/debian wheezy-backports main

Then run:
	
	sudo apt-get update
	sudo aptitude -s install linux-image-3.14-0.bpo.2-686-pa

Aptitude will simulate installing of the package. It may will break some dependencies so conflicts would be needed to be resolved, then aptitude will offer some choices. Just press `n` until you see an option you'd like, then press `y`. I choose 'upgrading initramfs-tools and then install kernel image'. Then just rerun command without `-s` and aptitude will install kernel and resolve all dependencies. Then just reboot and look for new network adapters using `ip link`.

