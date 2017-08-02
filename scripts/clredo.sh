#!/bin/bash
for file in \
        /var/log/*.gz                           \
        /var/log/nginx/error.log.?.gz           \
        /var/log/nginx/error.log.??.gz          \
        /var/log/cnuapp/*.log.????_??_??        \
        /var/log/cnuapp/*.log.????_??_??.??     \
        /var/log/postgresql/*.gz                \
        /var/log/postgresql/*main.log.?         \
        /var/log/postgresql/*main.log.??        \
        /var/log/cnuapp/lsws.d/@40000000????????????????.s      \
        /var/log/cnuapp/services.d/@400000004???????????????.s  \
        /var/log/cnuapp/space.d/@400000004???????????????.s     \
        ; do
        echo "removing $file"
        sudo rm $file
done
for file in \
        /var/log/cnuapp/lsws.d/current                  \
        /var/log/cnuapp/services.d/current              \
        /var/log/cnuapp/space.d/current                 \
        /var/log/postgresql/postgresql-*-main.log       \
        /var/log/cnuapp/*.log                           \
        ; do
        echo "clearing $file"
        sudo cp /dev/null $file
done
