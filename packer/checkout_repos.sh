#!/bin/bash -ex

# download harvester
cd /home/vagrant/
wget https://github.com/TransparencyToolkit/CrawlerManager/archive/master.zip -O CrawlerManager-master.zip
unzip -o CrawlerManager-master.zip
cd /home/vagrant/CrawlerManager-master
bundle install --deployment

# download
cd /home/vagrant/
wget https://github.com/TransparencyToolkit/Harvester/archive/master.zip -O Harvester-master.zip
unzip -o Harvester-master.zip
cd /home/vagrant/Harvester-master
bundle install --deployment
