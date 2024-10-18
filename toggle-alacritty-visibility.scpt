#!/usr/bin/osascript

tell application (path to frontmost application as text)
    if name is "Alacritty" then
        set bid to id
        tell application "System Events" to tell (process 1 where bundle identifier is bid)
            set visible to false
        end tell
    else
        tell application "Alacritty"
            reopen
            activate
        end tell
    end if
end tell
