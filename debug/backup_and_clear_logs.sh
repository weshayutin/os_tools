#!/usr/bin/bash

date_time=`date +%F-%T`

function backup_log {
  echo "backing up log"
  echo $date_time
  mkdir $date_time
  cp * $date_time
}

function clear_log {
  echo "clearing logs"
  find . -maxdepth 1 -type f -exec /bin/sh -c "> '{}'" ';'
}


for dir in nova cinder keystone glance; do
  echo "In dir /var/log/$dir"
  if [ -d /var/log/$dir ]; then
    pushd /var/log/$dir
    backup_log
    clear_log
    popd
  fi
done

