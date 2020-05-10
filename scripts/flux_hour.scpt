#!/usr/bin/osascript

tell application "System Events" to tell process "Flux"
    tell menu bar item 1 of menu bar 2
        click
        click menu item "Disable for an hour" of menu 1
    end tell
end tell
