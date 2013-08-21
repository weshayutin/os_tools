git clone https://github.com/dprince/torpedo.git
pushd torpedo
gem build torpedo.gemspec
gem install --version >= 2.6.5 net-ssh
gem install net-scp
gem install --no-rdoc --no-ri  torpedo*.gem
