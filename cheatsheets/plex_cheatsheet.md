# PLEX CHEATSHEET
- share only a couple files/movies with another user: https://support.plex.tv/articles/shared-media/
- adding subtitles to local media: https://support.plex.tv/articles/200471133-adding-local-subtitles-to-your-media/
- rsync hard link rename trick: https://lincolnloop.com/blog/2012/jan/6/detecting-file-moves-renames-rsync/
- plex google home integration
    - doesnt exist, for home-assistant, try plex-assistant: https://github.com/maykar/plex_assistant
- stopping a stream, _should_ be able to do it in dashboard but might be issue:
    - https://forums.plex.tv/t/stop-playback-not-present-on-now-playing/366739
- web player requires widevine DRM, needed for playpack in webplayer (netflix/prime/spotify also use widevine)
- API - https://plexapi.dev/docs/plex


## MEDIA TYPE SUPPORT/PLAYBACK
- DirectStream vs DirectPlay
    - https://support.plex.tv/articles/200250387-streaming-media-direct-play-and-direct-stream/
- PLAYBACK TESTING (DS218j):
    - no transcoding, tested 5 simulatenous HD streams (mix of webplayer and vlc local) no problem, low cpu usage
    - 2 transcodes of sub 1080p movies barely kept up, once in a while one paused to buffer, 100%cpu on server
- web player generally supports most codecs
- if dashboard shows a stream as "indirect connection" 
    - it means stream is being relayed through plex cloud servers, not direct from plex server to client
- media support for plex player: https://support.plex.tv/articles/203810286-what-media-formats-are-supported/
- direct video playback limit on iphone app, get plexpass
    - https://support.plex.tv/articles/202526943-plex-free-vs-paid/
- `.avi` file gave _“This server is not powerful enough to convert video"_
    - https://support.plex.tv/articles/205002628-why-do-i-get-the-this-server-is-not-powerful-enough-to-convert-video-message/
        > AVI file container with XviD video inside it, that cannot be played natively by the Plex Web App.
    - plex web gave error, but plex iphone12 app works fine
- H265(HEVC) playback - dec2021
    - dec2021: Main 10 version is transcode for chromecast ultra, safari
        - plex desktop app is most reliably no transcode, android app and google tv is sometimes no transcode
    - DIRECT PLAY/STREAM: ios app, safari desktop web, plex desktop app
    - TRANSCODE: chromecast 1080p, chrome desktop web
- 4K playback: https://forums.plex.tv/t/info-plex-4k-transcoding-and-you-aka-the-rules-of-4k/378203
    - iOS app -> **NO** transcode
    - safari browser (osx) -> **NO** transcode
    - plex desktop app osx -> **NO** transcode
    - iOS play to 1080p chromecast -> transcodes (no surprise here)
    - iOS play to 4k-tv/4k-chromecast -> transcodes
    -  webplayer(chrome linux/mbp) -> transcodes video and audio
- hardware acceleration support: https://support.plex.tv/articles/115002178853-using-hardware-accelerated-streaming/
- plexDLNA
    - dashboard will show "DLNA generic"
    - Roku WILL TRANSCODE most things
        - _SIDENOTE_ synologyDLNA to roku didnt transcode same movies (tested a 4k movie too)
    - chromecast vlc (1080p tv and chromecast), basically never transcodes (4k movie tested)
    - local vlc (on osx and ubuntu), basically never transcodes (4k movie tested)
- limits of DLNA servers(standard from 2003): https://www.makeuseof.com/tag/dlna-still-used/
    - doesnt support modern mkv or avi containers, FLAC audio, some DLNA server will transcode to one it supports
- "automatically adjust quality" will transcode
    - https://support.plex.tv/articles/115007570148-automatically-adjust-quality-when-streaming/


## LIBRARY
- naming tv shows: https://support.plex.tv/articles/naming-and-organizing-your-tv-show-files/
- external subtitle files: https://support.plex.tv/articles/200471133-adding-local-subtitles-to-your-media/
- naming movies:
    - folder names support using underscores and dashes for movie names
    - accents,special chars,spaces: https://forums.plex.tv/t/accents-and-punctuation-in-file-names/127524
    - names with `&` and `'` get indexed fine
- database files are sqllite
- backup data: https://support.plex.tv/articles/201539237-backing-up-plex-media-server-data/

## SHARING
- can create tags and collections(special tags?) to organize: https://support.plex.tv/articles/201273953-collections/
    - to restrict tags for certain users on shares, need plex pass
- can share a library with a plex user by username or email
- can create smart playlists and share just the playlist
- can deauthorize(logout) individual devices: https://support.plex.tv/articles/115007577087-devices/


## OTHER
- too see your play history goto discover(leftbar)->activity
- plex docker - logs in `Library/Application Support/Plex Media Server/Logs`
    - in web, hit `console` on left panel to see logs
