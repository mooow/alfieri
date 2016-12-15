STAGE=0
stage Pre-installation

cat << EOF
Please verify that you have done the following steps:
    1. Partitioned the disks
    2. Formatted them (if needed)
    3. Mounted them inside /mnt
EOF
_continue

stage "Connect to the internet"
: ping www.google.com -c2 ||  die "[FATAL] Check your internet connection before running this script"

stage "Date set-up"
: ntpdate $NTP_SERVER || die "[ERROR] NTP failed."

loadstages ${ALFIERI_STAGES}/0*.stage

echo "Pre-installation completed."
