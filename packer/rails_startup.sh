#!/bin/bash -e

export CRAWLER_HOME=/home/vagrant/CrawlerManager-master
cd $CRAWLER_HOME
if [ -f "$CRAWLER_HOME/tmp/pids/server.pid" ]; then
  kill $(cat "$CRAWLER_HOME/tmp/pids/server.pid")
  rm "$CRAWLER_HOME/tmp/pids/server.pid"
fi
bundle exec rails server -p 9506 -d 2>&1 > "$CRAWLER_HOME/log/xprofile-output.log"

export HARVESTER_HOME=/home/vagrant/Harvester-master
cd $HARVESTER_HOME
if [ -f "$HARVESTER_HOME/tmp/pids/server.pid" ]; then
  kill $(cat "$HARVESTER_HOME/tmp/pids/server.pid")
  rm "$HARVESTER_HOME/tmp/pids/server.pid"
fi
bundle exec rails server -p 3000 -d 2>&1 > "$HARVESTER_HOME/log/xprofile-output.log"
