 # echo 'Providing Links to home directory'
 # ln -s /vagrant/backend/ ~/
 # ln -s /vagrant/www ~/

# echo 'Installing essential packages'
# apt-get -y update
# apt-get -y install linux-headers-$(uname -r) build-essential
# apt-get -y install curl git-core libssl-dev openssl zlib1g-dev libreadline6-dev gem libyaml-dev libpcre3 libpcre3-dev

# apt-get -y install ruby1.9.3
# update-alternatives --set gem /usr/bin/gem1.9.1
# apt-get -y update

#gem install musicbrainz

#Required?
echo 'installing php components'
apt-get -y install php5

echo 'installing resque and requirements'
gem install resque
gem install god

echo 'installing redis and requirements'
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
cd ..

echo 'installing packages required for mysql2'
apt-get -y install libmysqlclient-dev
gem install mysql2
gem install net-ssh-gateway

echo 'installing mechanize and scraping components'
gem install mechanize
gem install sanitize
gem install json

echo 'installing mysql client and server'
apt-get -y install mysql-client
apt-get -y install mysql-server

echo 'Installing production-helper gems'
gem install awesome_print
gem install require_all

gem install bundler

exit
