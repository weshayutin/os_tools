pushd /root/firestack
export GROUP_TYPE=libvirt
export DISTRO_NAME=rhel
export DEBUG=true
rake kytoon:create GROUP_CONFIG="config/my_rhel_server_group.json"
rake rhel:build_packstack --trace
rake rhel:create_rpm_repo --trace

#remove local rpms, add new rpms, recreate repo
rm -Rf /var/www/html/repos/packstack/*.rpm
scp -rv root@`rake kytoon:ip`:/var/www/html/repos/*.rpm /var/www/html/repos/packstack/
popd

#kill the old vm
rake kytoon:delete

#recreate the repodata locally to avoid yum errors
rm -Rf /var/www/html/repos/packstack/repodata
pushd /var/www/html/repos/packstack
createrepo .
popd


if [ `ls /var/www/html/repos | wc -l` == 4 ];then 
 echo "found 3"
 mkdir -p  /var/www/html/backups/$(date +%F)
 cp -Rv /var/www/html/repos/* /var/www/html/backups/$(date +%F)
else
 echo "packstack build failed" | mail -s "packstack build failed on $HOSTNAME" whayutin@redhat.com
fi

for i in `find /var/www/html/backups -maxdepth 1 -type d -mtime +30 -print`; do echo -e "Deleting directory $i";rm -rf $i; done



