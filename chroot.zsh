# This file is part of alfieri
# Alfieri is  Copyright (c) 2016 Lorenzo Mureu <mureulor@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

STAGE=200
stage "Installation (chroot)"

stage "Set the hostname"
: echo $HOSTNAME > /etc/hostname

stage "Set the time zone"
: ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
: hwclock --systohc --utc

stage "Selecting locales"
: cp /etc/locale.gen /etc/locale.gen.bak
: cp ${ALFIERI_DIR}/locale.gen /etc/locale.gen
: locale-gen
: echo LANG=$TARGET_LANG > /etc/locale.conf

stage "Generate initramfs"
[ -f ${ALFIERI_DIR}/mkinitcpio.conf ] && : cp ${ALFIERI_DIR}/mkinitcpio.conf /etc/mkinitcpio.conf
mkinitcpio -p linux

stage "Installing required packages"
: pacman -Syu - < ${ALFIERI_DIR}/2xx.pacman

stage "Bootloader installation"
: grub-install --target=i386-pc --recheck $BOOTLOADER_DEVICE
: grub-mkconfig -o /boot/grub/grub.cfg

stage "Root password"

loadstages ${ALFIERI_STAGES}/2*.stage

stage "Exit chroot"
: exit



