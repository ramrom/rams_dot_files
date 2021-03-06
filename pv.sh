#!/bin/sh

# case "$1" in
#     *.tar*) tar tf "$1";;
#     *.zip) unzip -l "$1";;
#     *.rar) unrar l "$1";;
#     *.7z) 7z l "$1";;
#     *.pdf) pdftotext "$1" -;;
#     *) bat --color=always "$1";;
# esac

# for Linux use mediainfo, otherwise assume Darwin
mmcmd="mdls"; [ "$(uname)" = "Linux" ] && mmcmd="mediainfo"

mimetype=$(file --mime-type --brief --dereference "$1")

case "$mimetype" in
    video/*|audio/*|image/*) $mmcmd "$1";;
    # image/*) chafa "$1";;  # cool but only sometimes works and slow
    application/json) jq -C . "$1";;
    application/zip) unzip -l "$1";;  # NOTE: -l only in Linux
    application/x-rar) unrar l "$1";;
    application/vnd.debian*) dpkg-deb -I "$1";;  # NOTE: dpkg-deb linux only
    application/x-iso9660-image) isoinfo -d -i "$1";; #NOTE: isoinfo linux only
    application/*7z*) 7z l "$1";;
    text/*) bat --color=always "$1";;
    *) bat --color=always "$1";;
esac
