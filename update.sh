#!/bin/bash

FILELIST="
regex:tf/tf2_misc_.*
tf/steam.inf
"

require_command() {
    if [ ! -x "$(command -v "$1")" ]; then
        echo "Command $1 is required but can't be found"
        exit 1
    fi
}

function main() {
    BASE="$(realpath "$(dirname "$0")")" 

    require_command "depotdownloader"
    require_command "vpk"

    # Download required server files
    depotdownloader                     \
        -app 232250                     \
        -dir "$BASE/files"              \
        -filelist <(echo "$FILELIST")

    # Extract game version
    GAMEVER="$(cat "$BASE/files/tf/steam.inf" | awk -F= '/^PatchVersion/ { print $2 }')"
    echo "Found game version: $GAMEVER"
    echo "Game version: $GAMEVER" >> "$BASE/version.txt"

    # Extract popfiles
    vpk                                     \
        -x "$BASE"                          \
        -name "*.pop"                       \
        -nd                                 \
        "$BASE/files/tf/tf2_misc_dir.vpk"
}

main
