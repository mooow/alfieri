STAGE=100
stage Installation

stage Installing base packages
: pacstrap /mnt base base-devel

stage Generate fstab
: genfstab -p -U /mnt >> /mnt/etc/fstab

stage Copy alfieri into target system
: mkdir -p ${TARGET_ALFIERI_DIR}
: cp -r "${ALFIERI_DIR}" /mnt/${TARGET_ALFIERI_DIR}

laodstages ${ALFIERI_STAGES}/1*.stage

stage Chrooting into target system
: arch-chroot /mnt ${TARGET_ALFIERI_DIR}/${ALFIERI_BIN} ${TARGET_STAGE}

STAGE=300

stage Loading after-chroot external stages
loadstages ${ALFIERI_STAGES}/3*.stage

stage Reboot
: umount -R /mnt
: reboot
