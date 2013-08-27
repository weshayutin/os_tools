PACKAGE=$1
pushd /root/firestack
export GROUP_TYPE=libvirt
export DISTRO_NAME=centos
export DEBUG=true
rake kytoon:create GROUP_CONFIG="config/my_rhel_server_group.json"

if [ $PACKAGE == "torpedo" ]; then
 rake torpedo:build_packages --trace
elif [ $PACKAGE == "packstack" ]; then
 rake rhel:build_packstack --trace
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
 scp -rv root@$IP:/var/www/html/repos/*.rpm /var/www/html/repos/$PACKAGE

 #recreate the repodata locally to avoid yum errors
 rm -Rf /var/www/html/repos/$PACKAGE/repodata
 pushd /var/www/html/repos/$PACKAGE
 createrepo .
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
#
for i in `find /var/www/html/backups -maxdepth 1 -type d -mtime +30 -print`; do echo -e "Deleting directory $i";rm -rf $i; done



