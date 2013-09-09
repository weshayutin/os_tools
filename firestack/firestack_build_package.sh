#!/bin/bash
echo "working dir =" $PWD
source /root/.bashrc

PACKAGE=$1
export GROUP_TYPE=libvirt
export DISTRO_NAME=centos
export DEBUG=True
export LIBVIRT_USE_SUDO=True
export RAILS_ENV=production

trap "rake kytoon:delete" INT TERM EXIT # cleanup the group on exit

kytoon list
#rake -s kytoon:create GROUP_CONFIG=/root/firestack/config/server_group.json --trace
GROUP_CONFIG=config/server_group.json rake -s kytoon:create --trace
if [ $? -ne 0 ]; then
 echo "FAILED TO kytoon:create"
 exit
fi

if [ $PACKAGE == "torpedo" ]; then
 rake torpedo:build_packages 
 rake fog:build_packages 
elif [ $PACKAGE == "packstack" ]; then
 rake rhel:build_packstack 
else 
 echo "either build packstack, or torpedo"
 exit
fi

rake rhel:create_rpm_repo --trace

#remove local rpms, add new rpms, recreate repo
IP=`rake kytoon:ip`
COUNT=`ssh root@$IP ls /var/www/html/repos/ | wc -l`
echo $COUNT
#
popd
#
echo "If torpedo rpms and repo dir have been created, proceed"
if [ $COUNT > 2 ];then 
 mkdir -p /var/www/html/repos/$PACKAGE
 rm -Rf /var/www/html/repos/$PACKAGE/*.rpm
 scp -r root@$IP:/var/www/html/repos/*.rpm /var/www/html/repos/$PACKAGE

 #recreate the repodata locally to avoid yum errors
 rm -Rf /var/www/html/repos/$PACKAGE/repodata
 pushd /var/www/html/repos/$PACKAGE
 createrepo .
 if [ $PACKAGE == "packstack" ]; then
  git clone https://github.com/stackforge/packstack.git 
  pushd packstack
  git show > /var/www/html/repos/$PACKAGE/last_commit.txt
  popd
  rm -Rf packstack
 fi
 popd
else
 echo "$PACKAGE build failed" | mail -s "packstack build failed on $HOSTNAME" whayutin@redhat.com
fi

pushd /root/firestack
#kill the old vm
rake kytoon:delete
popd

#BACKUP 
echo "BEGIN BACKUP"
if [ `ls /var/www/html/repos/$PACKAGE | wc -l` > 2 ];then 
 echo "found packages, moving on"
 mkdir -p  /var/www/html/backups/$PACKAGE/$(date +%F)
 cp -Rv /var/www/html/repos/$PACKAGE* /var/www/html/backups/$PACKAGE/$(date +%F)
fi
##
for i in `find /var/www/html/backups -maxdepth 1 -type d -mtime +30 -print`; do echo -e "Deleting directory $i";rm -rf $i; done



