git clone https://github.com/dprince/torpedo.git

mkdir rpms
pushd rpms
for PACKAGE in rubygems-1.8.10-1.el6.noarch.rpm rubygem-mime-types-1.18-1.el6.noarch.rpm rubygem-builder-2.1.2-1.el6.noarch.rpm rubygem-thor-0.14.6-2.el6.noarch.rpm rubygem-net-ssh-2.3.0-1.el6.noarch.rpm rubygem-formatador-0.2.1-1.el6.noarch.rpm rubygem-multi_json-1.2.0-1.el6.noarch.rpm rubygem-net-scp-1.0.4-1.el6.noarch.rpm rubygem-nokogiri-1.5.2-1.el6.x86_64.rpm rubygem-ruby-hmac-0.4.0-1.el6.noarch.rpm; do
[ -f "$PACKAGE" ] || wget -q http://yum.theforeman.org/releases/1.0/el6/x86_64/$PACKAGE
done
popd

pushd torpedo
gem build torpedo.gemspec
gem install --version >= 2.6.5 net-ssh
gem install net-scp
gem install -f --no-rdoc --no-ri  torpedo*.gem
