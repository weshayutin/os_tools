pushd /root/firestack
export GROUP_TYPE=libvirt
export DISTRO_NAME=rhel
export DEBUG=true
rake kytoon:create GROUP_CONFIG="config/my_rhel_server_group.json"
rake rhel:build_packstack --trace
rake rhel:create_rpm_repo --trace

#remove local rpms, add new rpms, recreate repo
rm -Rf /var/www/html/repos/*
scp -rv root@`rake kytoon:ip`:/var/www/html/repos/* /var/www/html/repos/
popd

#recreate the repodata locally to avoid yum errors
rm -Rf /var/www/html/repos/repodata
pushd /var/www/html/repos
createrepo .
popd


