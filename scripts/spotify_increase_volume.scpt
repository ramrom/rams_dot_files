#!/usr/bin/osascript

tell application "Spotify"
    if sound volume is less than 50 then
        set sound volume to (sound volume + 10)
    end if
end tell
