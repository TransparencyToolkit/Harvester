#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

# install the brightbox repo and latest ruby 2.1 version
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install -y ruby2.1 ruby2.1-dev nodejs

# install bundler globally so the app installs can use it later
sudo gem install bundler

# rails deps
sudo apt-get install -y build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev \
  libreadline-dev libncurses5-dev libffi-dev libcurl3 libcurl3-gnutls libcurl4-openssl-dev \
  libmagickcore-dev libmagickwand-dev libsqlite3-dev libpq-dev unzip

# add neo4j repo and install the daemon
wget -O - https://debian.neo4j.org/neotechnology.gpg.key | sudo apt-key add -
sudo apt-add-repository -y 'deb http://debian.neo4j.org/repo stable/'
sudo apt-get update
sudo apt-get install -y neo4j

# disable auth since neo4j listens on localhost only by default
sudo sed -i -e 's/dbms\.security\.auth_enabled=true/dbms.security.auth_enabled=false/' /etc/neo4j/neo4j-server.properties
sudo /etc/init.d/neo4j-service restart
