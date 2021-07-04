#!/bin/sh

# SAMPLE `transmission-remote -l` OUTPUT:
# ID     Done       Have  ETA           Up    Down  Ratio  Status       Name
#    1    n/a       None  Unknown      0.0     0.0   None  Idle         Foo2
#    3     0%    3.13 MB  1 hrs        0.0  1066.0    0.0  Downloading  Foo
#    3     0%    3.13 MB  1 hrs        0.0  1066.0    0.0  Up & Down    Foo4
#    3     0%    3.13 MB  1 hrs        0.0  1066.0    0.0  Seeding      Foo3
# Sum:           3.13 MB               0.0  1066.0

# remove the first and last line
torrents="$(transmission-remote -l | tail -n+2 | head -n-1)"

if [ -n "$torrents" ]; then
    if echo "$torrents" | grep -E 'Downloading|Seeding|Up\s\&\sDown' > /dev/null; then
        echo "#[fg=brightyellow]#[bg=red]ACT_TORRNT#[default]"
    else
        echo "#[fg=blue]#[bg=colour178]IDLE_TORRNT#[default]"
    fi
fi
