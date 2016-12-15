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



