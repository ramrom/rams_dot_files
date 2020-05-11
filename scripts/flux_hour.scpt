#!/usr/bin/osascript

-- ignoring application responses
--     tell application "System Events" to tell process "Flux"
--         click menu bar item 1 of menu bar 2
--     end tell
-- end ignoring

-- do shell script "killall System\\ Events"
-- delay 0.1

tell application "System Events" to tell process "Flux"
    tell menu bar item 1 of menu bar 2
        click
        -- click menu item "for an hour" of menu "Disable"
    end tell
end tell

