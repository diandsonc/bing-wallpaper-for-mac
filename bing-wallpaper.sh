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
MAX_ATTEMPTS=3

# Option parsing
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -p | --PICTURE_DIR)
            PICTURE_DIR="$2"
            shift
            ;;
        -r | --resolution)
            RESOLUTION="$2"
            shift
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        -v | --version)
            printf "%s\n" $VERSION
            exit 0
            ;;
        *)
            (printf >&2 "Unrecognized option: %s\n" "$1")
            usage
            exit 1
            ;;
    esac
    shift
done

transform_urls() {
    sed -e "s/\\\//g" |
        sed -e "s/[[:digit:]]\{1,\}x[[:digit:]]\{1,\}/$RESOLUTION/" |
        tr "\n" " "
}

# Parse bing.com and acquire picture URL
get_url() {
    read -ra url < <(curl -sL https://www.bing.com |
        grep -Eo "url:'.*?'" |
        sed -e "s/url:'\([^']*\)'.*/https:\/\/bing.com\1/" |
        transform_urls)
}

# Get filename
get_wallpaper() {
    filename=$(echo "$url" | sed -e 's/.*[?&;]id=\([^&]*\).*/\1/' | grep -oe '[^\.]*\.[^\.]*$')

    if [ ! -f "$PICTURE_DIR/$filename" ]; then
        printf "Downloading wallpaper: %s...\n" "$filename"
        curl -Lo "$PICTURE_DIR/$filename" "$url"
    else
        printf "Skipping file: %s already exist\n" "$filename"
        SET_WALLPAPER=false
    fi
}

# Create picture directory if it doesn't already exist
mkdir -p "${PICTURE_DIR}"
ATTEMPTS=1
while [ -z "$url" ] && [ $ATTEMPTS -le $MAX_ATTEMPTS ]; do
    get_url

    if [ -z "$url" ]; then
        sleep 60s
    else
        get_wallpaper
    fi

    if [ $ATTEMPTS == $MAX_ATTEMPTS ]; then
        SET_WALLPAPER=false
        printf "Download failed."
    fi

    ((ATTEMPTS++))
done

# Set wallpaper
if $SET_WALLPAPER; then
    /usr/bin/osascript <<END
tell application "System Events" to set picture of every desktop to ("$PICTURE_DIR/$filename" as POSIX file as alias)
END
fi
