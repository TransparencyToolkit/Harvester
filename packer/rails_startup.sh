#!/bin/bash

export CRAWLER_HOME=/home/vagrant/CrawlerManager-master
cd $CRAWLER_HOME
if [ -f "$CRAWLER_HOME/tmp/pids/server.pid" ]; then
  CRAWLER_PID=`cat "$CRAWLER_HOME/tmp/pids/server.pid"`

  if [ -e "$CRAWLER_PID" ]; then
    kill "$CRAWLER_PID"
  fi
fi
bundle exec rails server -p 9506 -d 2>&1 >> "$CRAWLER_HOME/log/xprofile-output.log"

export HARVESTER_HOME=/home/vagrant/Harvester-master
cd $HARVESTER_HOME
if [ -f "$HARVESTER_HOME/tmp/pids/server.pid" ]; then
  HARVESTER_PID=`cat "$HARVESTER_HOME/tmp/pids/server.pid"`

  if [ -e "$HARVESTER_PID" ]; then
    kill "$HARVESTER_PID"
  fi
fi
bundle exec rails server -p 3000 -d 2>&1 >> "$HARVESTER_HOME/log/xprofile-output.log"

midori http://localhost:3000 &
