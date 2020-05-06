#/usr/bin/osascript

on run (trackingValue)
--Open and activate System Preferences
tell application "System Preferences" to activate

--Attempt to change settings using System Events
tell application "System Events"
    tell process "System Preferences"
        try
            delay 1
            --Open the "Mouse" pane
            click menu item "Mouse" of menu "View" of menu bar 1
            delay 0.5
            tell window "Mouse"
                tell slider "Tracking speed" of tab group 1
                    set value to round of trackingValue rounding down
                end tell
            end tell
        on error theError
            --An error occured
            display dialog ("Sorry, an error occured while altering Mouse settings:" & return & theError) buttons "OK" default button "OK"
        end try
    end tell
end tell

tell application "System Preferences" to quit
end run
