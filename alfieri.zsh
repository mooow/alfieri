#!/usr/bin/zsh
source "/opt/alfieri/alfieri.cfg"   # Load configuration file

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

autoload -Uz colors && colors

ALFIERI_STAGES="${ALFIERI_DIR}/stages"

loadstages() {
    for stage in "$@"
    do
        echo "Loading stage: $stage"
        source $stage
    done
}

stage() {
    echo -n "$fg_bold[yellow]"
    printf "Stage %3d: " $STAGE
    echo -n "$reset_color"
    echo "$@"
    STAGE=$[$STAGE + 1]
}

echorun() {
    echo "$fg_color[blue]$@$reset_color"
    "$@"
}

echorunno() {
    echorun "$@" &> /dev/null
}

die() {
    echo "$@"
    exit 1
}

_continue() {
    echo -n "$fg_color[red]"
    echo -n "Do you want to continue? [y/N]"
    echo -n "$reset_color"
    read -r cont
    [[ "$cont" != "Y" && "$cont" != "y" ]] && exit 0
}

usage() {
    cat << EOF
Syntax: $0 [stage]
If stage is omitted, 00 (double zero) is assumed.
Possible values for stage:
    000: pre-installation   (setup)
    100: installation       (before chroot)
    200: installation       (inside chroot)
    300: installation       (after chroot)
    400: post-installation  (after reboot)
EOF
}

alias :='echorun'
alias ::='echorunno'

[ $# -gt 1 ] && usage       # Syntax: $0 
opt=$1                      # If an arg is provided, that is used.
[ $# -eq 0 ] && opt="000"   # Otherwise 00 is assumed
case $opt in
000)
    source "${ALFIERI_DIR}/pre-installation.zsh"
    ;&
100)
    source "${ALFIERI_DIR}/installation.zsh"
    ;&
200)
    source "${ALFIERI_DIR}/chroot.zsh"
    ;;
400)
    source "${ALFIERI_DIR}/post-installation.zsh"
    ;;
*)
    usage
    ;;
esac
