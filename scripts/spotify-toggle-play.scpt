#!/usr/bin/osascript

using terms from application "Spotify"
    if player state of application "Spotify" is paused then
        tell application "Spotify" to play
    else
        tell application "Spotify" to pause
    end if
end using terms from
