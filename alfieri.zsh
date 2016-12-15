CONFIGURATION_FILE = "alfieri.zsh"
source "${CONFIGURATION_FILE}"
ALFIERI_STAGES = "${ALFIERI_DIR}/stages"

loadstages() {
    for stage in "$@"
    do
        echo "Loading stage: $stage"
        source $stage
    done
}

stage() {
    printf "Stage %3d: " $STAGE
    echo "$@"
    STAGE=$[$STAGE + 1]
}

echorun() {
    echo "$@"
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
    echo -n Do you want to continue? [y/N]
    read -r cont
    [[ "$cont" != "Y" && "$cont" != "y" ]] && exit 0
}

usage() {
    cat << EOF Syntax: $0 [stage]
If stage is omitted, 00 (double zero) is assumed.
Possible values for stage:
    000: pre-installation   (setup)
    100: installation       (pacstrap)
    200: installation       (from chroot)
    300: post-installation
EOF
}

alias :='echorun'
alias ::='echorunno'

[ $# -gt 1 ] && usage       # Syntax: $0 
opt=$1                      # If an arg is provided, that is used.
[ $# -eq 0 ] && opt="00"    # Otherwise 00 is assumed
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
