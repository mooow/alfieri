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

STAGE=0
stage "Pre-installation"

cat << EOF
Please verify that you have done the following steps:
    1. Partitioned the disks
    2. Formatted them (if needed)
    3. Mounted them inside /mnt
EOF
_continue

ismountpoint /mnt || die "You MUST mount your target system's root on /mnt"

stage "Connect to the internet"
: ping www.google.com -c2 ||  die "[FATAL] Check your internet connection before running this script"

stage "Date set-up"
: ntpdate $NTP_SERVER || die "[ERROR] NTP failed."

loadstages ${ALFIERI_STAGES}/0*.stage

echo "Pre-installation completed."
