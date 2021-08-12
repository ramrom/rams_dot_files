#!/usr/bin/osascript

(*************************************************************************

Shortflux - menu shortcuts for f.lux on OS X

Allows picking items from the f.lux menubar menu, with hotkeys or other
automation. Works even if the menubar icon is hidden with Bartender.
Especially useful for toggling "Movie mode" or "Disable for an hour".
Set the menu item you want in the Settings section below. You can make
multiple copies of the script with different names, to trigger different
functions.

Paste this into Script Editor, then save it as a script or an
application, depending how you will trigger it. Then use your favourite
launcher app, such as Automator, Karabiner, BetterTouchTool, Alfred,
FastScripts, QuicKeys, and so on, to run it. There may be a delay of
several seconds before the menu item is picked, during which you should
hold your breath.

Shortflux Version 1.0a.20160131.0
by Elhem Enohpi 2016 - Artistic Licence 2.0
f.lux is a trademark of Flux Software LLC
Elhem Enohpi and Shortflux are not associated with Flux Software LLC

*************************************************************************)

-- Settings --

property mainItem : "Color Effects"
-- set to "Preferences...", "Color Effects", "Disable", etc.,
-- make sure to use quote marks.

property subItem : "Movie mode"
-- set to submenu item, if there is one. Use "for this app" with Disable,
-- to toggle disable for the current application.

-- end of Settings --


if mainItem is "Disable" and subItem is "for this app" then set subItem to 3
tell application "System Events" to tell process "Flux"
	click menu bar item 1 of menu bar 1
	tell menu 1 of menu bar item 1 of menu bar 1
		select menu item mainItem
		delay 0.6
		click menu item mainItem
		if menu 1 of menu item mainItem exists then
			tell menu 1 of menu item mainItem
				select menu item subItem
				delay 0.6
				click menu item subItem
			end tell
		end if
	end tell
end tell
