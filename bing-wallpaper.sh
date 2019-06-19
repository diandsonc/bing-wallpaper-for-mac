#!/usr/bin/env bash
# shellcheck disable=SC1117

readonly SCRIPT=$(basename "$0")
readonly VERSION='0.1.0'
readonly RESOLUTIONS=(1920x1200 1920x1080 800x480 400x240)

usage() {
cat <<EOF

Usage: $SCRIPT [OPTIONS]

Options:
  -p, --picturedir <picture_dir>        The full path to the picture download dir (default: "$HOME/Pictures/bing-desktop-wallpapers/")
  -r, --resolution <resolution>         The resolution of the image to retrieve ("1920x1200"|"1920x1080"|"800x480"|"400x240") (default: "1920x1080")
  -h, --help                            Print this screen
  -v, --version                         Print version information and quit

EOF
}

# Defaults
PICTURE_DIR="$HOME/Pictures/bing-desktop-wallpapers/"
RESOLUTION="1920x1080"
SET_WALLPAPER=true

# Option parsing
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -p|--PICTURE_DIR)
            PICTURE_DIR="$2"
            shift
            ;;
        -r|--resolution)
            RESOLUTION="$2"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -v|--version)
            printf "%s\n" $VERSION
            exit 0
            ;;
        *)
            (>&2 printf "Unrecognized option: %s\n" "$1")
            usage
            exit 1
            ;;
    esac
    shift
done
