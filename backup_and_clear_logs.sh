#!/usr/bin/bash

date_time=`date +%F%T`

declare -a components=(nova cinder keystone glance)

for dir in ${components[@]}
do
  pushd /var/log/$dir
  backup_log
  clear_log
done

fucntion backup_log {
  echo "backing up log"
  mkdir $date_time
  cp * $date_time
}

function clear_log {
  echo "clearing logs"
  find . -maxdepth 1 -type f -exec /bin/sh -c "> '{}'" ';'
}
