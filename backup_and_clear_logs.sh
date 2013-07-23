#!/usr/bin/bash

date_time=(date +%F%T)
pushd /var/log/nova
mkdir date_time
cp * date_time
find . -maxdepth 1 -type f -exec /bin/sh -c "> '{}'" ';'

