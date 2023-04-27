#!/bin/sh

# FROM man page, 5 args passed in
    # (1) current file name, (2) width, (3) height, (4) horizontal position, and (5) vertical position

# case "$1" in
#     *.tar*) tar tf "$1";;
#     *.zip) unzip -l "$1";;
#     *.rar) unrar l "$1";;
#     *.7z) 7z l "$1";;
#     *.pdf) pdftotext "$1" -;;
#     *) bat --color=always "$1";;
# esac

# if not Linux assume Darwin
MMBIN="mdls"; [ "$(uname)" = "Linux" ] && MMBIN="mediainfo"
BATBIN="bat"; [ $(uname) = "Linux" ] && BATBIN='batcat'

mimetype=$(file --mime-type --brief --dereference "$1")

case "$mimetype" in
    video/*|audio/*|image/*) $MMBIN "$1";;
    # image/*) chafa "$1";;  # cool but only sometimes works and slow
    application/json) jq -C . "$1";;
    application/zip) unzip -l "$1";;  # NOTE: -l only in Linux
    application/x-rar) unrar l "$1";;
    application/vnd.debian*) dpkg-deb -I "$1";;  # NOTE: dpkg-deb linux only
    application/x-iso9660-image) isoinfo -d -i "$1";; #NOTE: isoinfo linux only
    application/*7z*) 7z l "$1";;
    text/*) $BATBIN --color=always "$1";;
    *) $BATBIN --color=always "$1";;
esac
