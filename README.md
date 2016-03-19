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

When you're done running DocumentLoader

1. Stop neo4j `rake neo4j:stop

## Packaging

A re-usable Virtualbox image containing Harvester and CrawlerManager can be created using
[Packer](http://packer.io) and [Vagrant](http://vagrantup.com).

The created image:
* Boots straight into an Xubuntu desktop
* Contains all dependent services
* Runs both rails apps on login

To create a Virtualbox image:

1. Either run *vagrant up* or *vagrant add box ubuntu/trusty64* to download the base image
2. Run *packer build packer/build-config/virtualbox.json*

The packaging process is faily slow, so if you need to modify or test it, you can
also run it against a standard vagrant machine. This way there is no cleanup or
packaging and the commands are run over SSH, so you can selectively run only
certain parts of the process without having to repeat everything.

To build in testing mode:

1. Bring up a vagrant box using the supplied [Vagrantfile](Vagrantfile) by running *vagrant up*
2. Run *packer build packer/build-config/testing.json*
