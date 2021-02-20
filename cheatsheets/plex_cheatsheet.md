# PLEX CHEATSHEET
- share only a couple files/movies with another user: https://support.plex.tv/articles/shared-media/
- adding subtitles to local media: https://support.plex.tv/articles/200471133-adding-local-subtitles-to-your-media/
- rsync hard link rename trick: https://lincolnloop.com/blog/2012/jan/6/detecting-file-moves-renames-rsync/
- plex google home integration
    - doesnt exist, for home-assistant, try plex-assistant: https://github.com/maykar/plex_assistant
- stopping a stream, _should_ be able to do it in dashboard but might be issue:
    - https://forums.plex.tv/t/stop-playback-not-present-on-now-playing/366739


## MEDIA TYPE SUPPORT:
- media support for plex player: https://support.plex.tv/articles/203810286-what-media-formats-are-supported/
- video playback limit on iphone, maybe get plexpass
    - https://support.plex.tv/articles/202526943-plex-free-vs-paid/
- `.avi` file gave _“This server is not powerful enough to convert video"_
    - see https://support.plex.tv/articles/205002628-why-do-i-get-the-this-server-is-not-powerful-enough-to-convert-video-message/
        > AVI file container with XviD video inside it, that cannot be played natively by the Plex Web App.
    - plex web gave error, but plex iphone12 app works fine
- limits of DLNA servers(standard from 2003): https://www.makeuseof.com/tag/dlna-still-used/
    - doesnt support modern mkv or avi containers, FLAC audio, some DLNA server will transcode to one it supports

## LIBRARY
- naming tv shows: https://support.plex.tv/articles/naming-and-organizing-your-tv-show-files/
- naming movies:
    - folder names support using uderscores and dashes for movie names

## SHARING
- can create tags and collections(special tags?) to organize: https://support.plex.tv/articles/201273953-collections/
    - to restrict tags for certain users on shares, need plex pass
- can share a library with a plex user by username or email
- can create smart playlists and share just the playlist
