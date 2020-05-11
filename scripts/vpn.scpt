#!/usr/bin/osascript
-- good tool: xcode, opendevtools, accessibility inspector

-- tell application "System Events" to tell process "GlobalProtect"
tell application "System Events"
    tell application "GlobalProtect"
        click the menu bar item
        click the "Connect" button
    end tell
end tell


---- from automator
-- Click the menu bar item.
delay 1.702221
set timeoutSeconds to 2.000000
set uiScript to "click menu bar item 1 of menu bar 2 of application process \"GlobalProtect\""
my doWithTimeout( uiScript, timeoutSeconds )

-- Click the “Connect” button.
delay 0.589280
set timeoutSeconds to 2.000000
set uiScript to "click UI Element \"Connect\" of UI Element 1 of UI Element 1 of menu bar 2 of application process \"GlobalProtect\""
my doWithTimeout( uiScript, timeoutSeconds )

on doWithTimeout(uiScript, timeoutSeconds)
	set endDate to (current date) + timeoutSeconds
	repeat
		try
			run script "tell application \"System Events\"
" & uiScript & "
end tell"
			exit repeat
		on error errorMessage
			if ((current date) > endDate) then
				error "Can not " & uiScript
			end if
		end try
	end repeat
end doWithTimeout
