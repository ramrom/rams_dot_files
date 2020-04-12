if application "GlobalProtect" is running then
    tell application "GlobalProtect"
        -- click button "Connect" of menu bar
        -- menu bar, button , popover, Connect button
        tell "menu bar"
            click "Connect"
        end tell
    end tell
end if
