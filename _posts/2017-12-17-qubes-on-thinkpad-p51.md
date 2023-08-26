---
layout: post
title:  Qubes OS R3.2 on a ThinkPad P51
---

> Since Qubes OS R4.0.3 no workarounds or troubleshooting are required anymore and the ThinkPad P51 is now listed as one of the [community-recommended computers](https://forum.qubes-os.org/t/5560){:target="_blank"}.

With significant help from members of the [qubes-users](https://groups.google.com/forum/#!forum/qubes-users){:target="_blank"} mailing list, I was able to install [Qubes OS](https://www.qubes-os.org/){:target="_blank"} R3.2 on my new ThinkPad P51 (model 20HJS0BX00). The starting point was the Qubes OS [Hardware Compatibility List](https://www.qubes-os.org/hcl/){:target="_blank"} linking to [swami's post](https://groups.google.com/d/msg/qubes-users/ZFZT7mQNeWY/xZ1AiCYOAwAJ){:target="_blank"} on qubes-users, which describes or links all the steps below except for the use of the USB-to-Ethernet adapter to run the initial update.

*A little twist that distinguishes my ThinkPad from his is that my networking hardware requires kernel version 4.9 to run, while after the install Qubes OS runs version 4.4.* Therefore some extra steps and hardware are required to run the initial update to kernel 4.9 to make everything work:

* another computer running Fedora or Qubes OS with a Fedora qube (to create the USB sticks)
* Qubes installer USB stick prepared using Fedora's [livecd-tools](https://fedoraproject.org/wiki/How_to_create_and_use_Live_USB#Command_line_method:_Using_the_livecd-iso-to-disk_tool_.28Fedora_only.2C_non-graphical.2C_both_non-destructive_and_destructive_methods_available.29){:target="_blank"}
* [rEFInd](http://www.rodsbooks.com/refind/getting.html){:target="_blank"} live USB stick
* [Linux-friendly Ethernet-to-USB adapter](https://www.google.com/search?q=Linux-friendly+Ethernet-to-USB+adapter){:target="_blank"} (e.g. [the one from Apple](https://www.apple.com/shop/product/MC704LL/A/apple-usb-ethernet-adapter){:target="_blank"})

Create Qubes installer USB stick
--------------------------------

This step was described by [Dave C.'s post](https://groups.google.com/d/msg/qubes-users/4VsKdxnKHBk/mEb1VIImBAAJ){:target="_blank"} with additional important [input from Stephan Marwedel](https://groups.google.com/d/msg/qubes-users/4VsKdxnKHBk/Sf9vtED-BgAJ){:target="_blank"}.

1. Get the ISO, signature and signing key from the [Qubes OS Download](https://www.qubes-os.org/downloads/){:target="_blank"} page.
2. Follow the instructions [on digital signatures and key verification](https://www.qubes-os.org/security/verifying-signatures/){:target="_blank"}.
3. Install the 'livecd-tools' package.
4. Run `sudo livecd-iso-to-disk --efi --format Qubes-R3.2-x86_64.iso /dev/sda` (assuming /dev/sda is the USB stick).
5. Mount the newly created USB stick and edit /EFI/BOOT/xen.cfg. In this file, replace every occurrence of 'LABEL=Qubes-R3.2-x86_64' with 'LABEL=BOOT'.
6. Unmount and run `sudo dosfslabel /dev/sda BOOT` (assuming /dev/sda is the USB stick).

Create rEFInd live USB stick
----------------------------

1. Download the [USB flash drive image](http://sourceforge.net/projects/refind/files/0.11.2/refind-flashdrive-0.11.2.zip/download){:target="_blank"} from Roderick W. Smith's [rEFInd Boot Manager](http://www.rodsbooks.com/refind/getting.html){:target="_blank"} page.
2. Run `sudo dd if=refind-flashdrive-0.11.2.img of=/dev/sda bs=1M` (assuming /dev/sda is the USB stick).

BIOS settings
-------------

* boot in UEFI mode (not legacy)
* disable secure boot
* set graphics to discrete
* enable all virtualization features including VT-d

Install Qubes
-------------

1. Boot the ThinkPad with the Qubes installer USB stick and run through the normal setup routine.
2. When it is time to reboot, remove the Qubes installer USB stick and insert the rEFInd live USB instead.
3. Once in the rEFInd boot manager, select the /EFI/BOOT/xen.cfg entry to boot.
4. On the Qubes OS configuration screen, *do not create the sys-usb qube yet!*
5. Finish configuration and log into Qubes OS.

Using USB-to-Ethernet adapter to run initial update
---------------------------------------------------

Both [Taiidan](https://groups.google.com/d/msg/qubes-users/xUXez7OOqXM/S-lVCaE1CQAJ){:target="_blank"} and an earlier comment from [Yethal](https://groups.google.com/d/msg/qubes-users/t-Ot9ZqeBYA/_2Iy8_IODAAJ){:target="_blank"} helped me figure out this sequence:

1. connect the USB-to-Ethernet adapter and shutdown all qubes
2. in dom0 run `qvm-prefs -s sys-net pci_strictreset false`
3. add your USB controller to sys-net using the qubes manager
4. start sys-net and sys-firewall - you should now be online!
5. update the fedora-23 template
6. update dom0
7. reboot with rEFInd USB stick
8. use `uname -r` to make sure you are running kernel 4.9 in both dom0 and sys-net. In my case sys-net was now running kernel 4.9 but dom0 was still on 4.4. It took the extra step of running `sudo qubes-dom0-update --enablerepo=qubes-dom0-unstable kernel kernel-qubes-vm --best --allowerasing` to upgrade dom0 to kernel 4.9.
9. shutdown all qubes and remove the USB controller from sys-net
10. in dom0 run `qvm-prefs -s sys-net pci_strictreset true`
11. reboot with rEFInd USB stick

Fix EFI boot configuration
--------------------------

For some reason the EFI entry generated by the Qubes installer doesn't work, which is why we had to use the rEFInd live USB stick until now to boot the machine. This can be fixed, by downloading the following packets via [rpmfind.net](https://rpmfind.net/linux/rpm2html/search.php?query=efibootmgr&submit=Search+...&system=fedora&arch=x86_64){:target="_blank"}:

* efibootmgr-15-1.fc26.x86_64.rpm
* efivar-31-1.fc26.x86_64.rpm
* efivar-libs-31-1.fc26.x86_64.rpm

*Obviously those packets are not signed by the Qubes OS team and represent a security risk. Unfortunately the version of efibootmgr delivered with Qubes OS doesn't fix the issue (it might actually be the cause of it). So you have to decide whether you want to keep booting with the rEFInd live USB stick or if you take the risk of installing those packets in dom0.*

1. [copy the files to dom0](https://www.qubes-os.org/doc/copy-from-dom0/){:target="_blank"} and install them via `sudo dnf install efibootmgr-15-1.fc26.x86_64.rpm efivar-31-1.fc26.x86_64.rpm efivar-libs-31-1.fc26.x86_64.rpm`.
2. delete the old entry via `sudo efibootmgr -b 0000 -B`
3. create a new entry via `sudo efibootmgr -v -c -u -L Qubes -l /EFI/qubes/xen.efi -d /dev/nvme0n1
-p 1`
4. reboot *without* the rEFInd live USB stick

Done!

-----

Now the ThinkPad boots straight into Qubes OS R3.2 and all the hardware should work. During the installation we skipped [creating sys-usb](https://www.qubes-os.org/doc/usb/){:target="_blank"}, which one might want to enable now that everything works. After successfully upgrading to kernel 4.9 one may switch the graphics BIOS setting back to hybrid. Finally I'd like to thank [Unman](https://groups.google.com/d/msg/qubes-users/fXxHKv7CdSM/4AI5_tTXBwAJ){:target="_blank"} and [Rory](https://groups.google.com/d/msg/qubes-users/fXxHKv7CdSM/U1fi-jbfBQAJ){:target="_blank"} for their help with approaches that ultimately didn't work out but were definitely worth pursuing.
