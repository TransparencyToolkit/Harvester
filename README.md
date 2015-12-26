DocumentLoader
==============

Web interface and tool to calls various web and data scrawlers!

## Installing

Make sure you have the proper system dependencies with

- Install [neo4j](http://debian.neo4j.org)
- Intall Ruby on Rails
- On Debian, do the following:
  - `sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmagickcore-dev libmagickwand-dev`
- Get the DocumentLoader code `git clone https://github.com/TransparencyToolkit/DocumentLoader`
- Install Ruby dependencies with `bundle install`
- Now, go download and install the [CrawlerManager](https://github.com/TransparencyToolkit/CrawlerManager)


## Running DocumentLoader

*Note: make sure that neo4j is not running when starting DocumentLoader*

1. Start `CrawlerManager` in that directory `rail server -p 9506`
2. Start neo4j `rake neo4j:start`
3. Then run `rails server`
4. Go to [0.0.0.0:3000](http://0.0.0.0:3000) in a browser

When your done running DocumentLoader

1. Stop neo4j `rake neo4j:stop
