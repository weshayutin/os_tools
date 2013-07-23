#!/usr/bin/bash

date_time=`date +%F-%T`

function create_dir {
  echo "creating dir for debug files"
  mkdir /tmp/debug-$date_time
}

function tar_it_up {
  pushd /tmp/debug-$date_time
  tar -cvf debug.tar /tmp/debug-$date_time/*
  popd
}

create_dir

for dir in nova cinder keystone glance; do
  echo "In dir /var/log/$dir"
  if [ -d /var/log/$dir ]; then
    pushd /var/log/$dir
    cp *.log /tmp/debug-$date_time/
    popd
  fi
done

tar_it_up
