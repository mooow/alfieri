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

STAGE=100
stage "Installation"

stage "Installing base packages"
: pacstrap -c /mnt base base-devel zsh
# Please notice that zsh is required by alfieri itself :)

stage "Generate fstab"
: genfstab -p -U /mnt >> /mnt/etc/fstab

stage "Copy alfieri into target system"
: mkdir -p ${TARGET_ALFIERI_DIR}
: cp -r "${ALFIERI_DIR}" /mnt/${TARGET_ALFIERI_DIR}

laodstages ${ALFIERI_STAGES}/1*.stage

stage "Chrooting into target system"
: arch-chroot /mnt ${TARGET_ALFIERI_DIR}/${ALFIERI_BIN} ${TARGET_STAGE}

STAGE=300

stage "Loading after-chroot external stages"
loadstages ${ALFIERI_STAGES}/3*.stage

stage "Reboot"
: umount -R /mnt
: reboot
