---
layout: page
title: scaling multiple screens with very different DPI
---

When using Qubes OS with high DPI screens one has to set the DPI / scaling for dom0 and each of the qubes. But what if there are two screens supporting very different DPI? In the past my solution was to calculate some kind of compromise DPI value and then set it everywhere. As a result things looked a little bit too big on one screen and a little bit too small on the other. Also, many applications do not scale gracefully.

The solution turns out to be very simple and deliver outstanding results:

1. Set scale to 2 (192 DPI) using the various methods supported. For me `Xft.dpi:` in `/etc/X11/Xresources/x11-common` works best, because I use debian-minimal based templates without any settings daemon. The key here is to set a value like 2x or 3x (288 DPI) that makes it easy for the applications to scale. In dom0 I simply tell XFCE to scale by 2 and leave the font DPI setting to 96. You might also want to select one of the hDPI themes in the window manager setting.

2. Use `xrandr` on the command line to set the resolution of your screens, here an example: `xrandr --output LVDS-1 --mode 1920x1080 --scale 1.6x1.6 --output DP-2 --mode 3840x2160 --scale 1.5x1.5`. Play with the `--scale` parameter until it looks just right to you.

3. Store different versions of this into bash scripts: both monitors, the build-in one, only the 4k monitor, mirroring, extending the desktop and hook them up to keyboard shortcuts or panel buttons.
