# SYNOLOGY CHEATSHEET
----------------------------------------
- a storage pool is a basically a group of HDs and has some disk multiplexing type, SHR or RAID types
    - https://www.synology.com/en-global/knowledgebase/DSMUC/help/DSMUC/StorageManager/general
- a storage pool can contain many volumes, a volume is basically a dev linux device with a filesystem
     - storage pool can have multi-volume support, this is not default
- compatibility site: https://www.synology.com/en-us/compatibility
    - 218j can take hdds up to 16TB (all depends on models)
- TESTING NOTE: cifs mount, play 3 movies, no problems
- TIP: in web DSM can right click a file and download it to local machine

## GUIDES
- DS218j
    - user guide: https://global.download.synology.com/download/Document/Software/UserGuide/Firmware/DSM/6.2/enu/Syno_UsersGuide_NAServer_enu.pdf
    - installation: https://global.download.synology.com/download/Document/Hardware/HIG/DiskStation/18-year/DS218+/enu/Syno_HIG_DS218_Plus_enu.pdf

## SOFTWARE
- `Download Station` - torrent client
- `Drive Server` - private cloud drive
- `Media Server` - basically a DLNA server

## SHARING
- quickconnect: https://www.synology.com/en-uk/knowledgebase/DSM/help/DSM/Tutorial/cloud_set_up_quickconnect
- filestation: right click share file: https://www.synology.com/en-us/knowledgebase/DSM/help/FileStation/sharing
    - excerpt: can create 1000 share links, add validity periods, add a password
    - see all share links: file-station->tools->share-link-managers
- videostation - can create playlists that are publicly shared (with validity periods)
