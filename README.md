[![Build Status](https://travis-ci.org/diandsonc/bing-wallpaper-for-mac.svg?branch=master)](https://travis-ci.org/diandsonc/bing-wallpaper-for-mac)
# Bing Desktop wallpaper for Mac

## Information
A script to change your desktop background to the Bing daily image.


## Configuration
* Open file `com.bing.background.plist` and change as needed to point to `bing-wallpaper.sh`.
* Copy the *plist* file to, **$HOME/Library/LaunchAgents** and
loaded with the command `launchctl load $HOME/Library/LaunchAgents/com.bing.wallpaper.plist`. 
* To remove use the command `launchctl unload $HOME/Library/LaunchAgents/com.bing.wallpaper.plist`. 
* If you get the message `Path had bad ownership/permissions` use `chmod 755 $HOME/Library/LaunchAgents/com.bing.wallpaper.plist` 


## How to use?
```
$ ./bing-wallpaper.sh --help

Usage:
  bing-wallpaper.sh [options]

Options:
  -p, --picturedir <picture_dir>        The full path to the picture download dir 
                                        (default: "$HOME/Pictures/bing-desktop-wallpapers/")
  -r, --resolution <resolution>         The resolution of the image to retrieve 
                                        ("1920x1200"|"1920x1080"|"800x480"|"400x240") 
                                        (default: "1920x1080")
  -h, --help                            Print this screen
  -v, --version                         Print version information and quit

```