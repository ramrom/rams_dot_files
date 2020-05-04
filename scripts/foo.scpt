property appName : "GlobalProtect"

on listToText(entireContents) -- (Handler specialised for lists of System Events references.)
	try
		|| of entireContents -- Deliberate error.
	on error stuff -- Get the error message
	end try

	-- Parse the message.
	set astid to AppleScript's text item delimiters
	set AppleScript's text item delimiters to {"{", "}"} -- Snow Leopard or later.
	set stuff to text from text item 2 to text item -2 of stuff
	set AppleScript's text item delimiters to "\"System Events\", "
	set stuff to stuff's text items
	set AppleScript's text item delimiters to "\"System Events\"" & linefeed
	set stuff to stuff as text
	set AppleScript's text item delimiters to astid

	return stuff
end listToText

on main()
	tell application "System Events"
		tell application process appName
			set frontmost to true
			set {windowExists, menuExists} to {front window exists, menu bar 1 exists}
			set {winstuff, menustuff} to {missing value, missing value}
			if (windowExists) then set winstuff to my listToText(entire contents of front window)
			if (menuExists) then set menustuff to my listToText(entire contents of menu bar 1)
		end tell
	end tell

	return {winstuff:winstuff, menustuff:menustuff}
end main

main()
