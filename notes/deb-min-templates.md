---
layout: page
title: automate debian-minimal based template creation
---

This page summarizes how to automate debian-minimal based template creation to enjoy the following advantages:

* documentation of your customizations (do the work once)
* easy and fast upgrades (save time and effort)
* no need to backup templates (save backup disk space)

The recommended and more flexible way of doing this is to write [salt](https://www.qubes-os.org/doc/salt/) formula, while the more basic bash script based approach documented on this page works too and might be easier to understand. Obviously all the health warnings about running code in dom0 apply. In a nutshell: don't ever run any code that you don't trust. And the only way to truly trust code is to understand what it does.

## [The basics](#basics)

qvm-clone
qvm-run
qvm-copy-to-vm
qvm-shutdown
qvm-prefs