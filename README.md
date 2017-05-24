Harvester
=========

Harvester is a tool to crawl websites and OCR/extract metadata from documents,
all through a usable graphical interface. The goal is for journalists,
activists, and researchers to be able to rapidly collect open source
intelligence (OSINT) from public websites and convert any set of documents
into machine readable form without programming or complex technical setup.

Harvester requires
[DocManager](https://github.com/TransparencyToolkit/DocManager) so that it can
index the data with Elasticsearch. Harvester can also be used with
[LookingGlass](https://github.com/TransparencyToolkit/LookingGlass) to
seamlessly generate searchable archives of crawled data and processed
documents.

# Installation

## Dependencies

* [DocManager](https://github.com/TransparencyToolkit/DocManager) and all of
  its dependencies
* Ruby 2.4.1
* Rails 5
* Mongodb
* Curl
* Redis
* Tika and Tesseract
* (optionally) [LookingGlass](https://github.com/TransparencyToolkit/LookingGlass)

## Setup Instructions

1. Install the dependencies

* Download elasticsearch (https://www.elastic.co/downloads/elasticsearch)
* Download rvm (https://rvm.io/rvm/install)
* Install Ruby: Run `rvm install 2.4.1` and `rvm use 2.4.1`
* Install Rails: `gem install rails`
* Install Debian dependencies: `sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmagickcore-dev libmagickwand-dev mongodb`
* Follow the installation instructions for [DocManager](https://github.com/TransparencyToolkit/DocManager)
* Install Redis: [instructions for Debian](https://www.linode.com/docs/databases/redis/deploy-redis-on-ubuntu-or-debian#debian)

2. Install Tika & Tesseract (optional)

NOTE: By default document conversion (pdf, docs, etc..) is handled by
[GiveMeText](http://givemetext.okfnlabs.org), this approach sends your
documents over the clear internet. *DO NOT USE THIS* with sensitive documents,
instead install Tika & Tesseract as described below.

* Install dependencies: `apt-get install default-jdk maven unzip`
* Download Tika: Run `curl https://codeload.github.com/apache/tika/zip/trunk -o  trunk.zip` and `unzip trunk.zip`
* Go into Tika directory: `cd tika-trunk`
* Install Tika: Run `mvn -DskipTests=true clean install` and `cp tika-server/target/tika-server-1.*-SNAPSHOT.jar /srv/tika-server-1.*-SNAPSHOT.jar`
* Install Tesseract: Run `apt-get -y -q install tesseract-ocr tesseract-ocr-deu tesseract-ocr-eng`
* Run Tika: `java -jar tika-server/target/tika-server-*.jar` (use `--host=localhost --port=1234` for a custom host and port)

3. Get Harvester

* Clone repo: `git clone https://github.com/TransparencyToolkit/Harvester`
* Go into Harvester directory: `cd Harvester`
* Install RubyGems: Run `bundle install`

4. Run Harvester

* Start DocManager: Follow the instructions on the
  [DocManager](https://github.com/TransparencyToolkit/DocManager) repo
* Configure Project: Edit the file in `config/initializers/project_config` so
  that the PROJECT_INDEX value is the name of the index in the
  [DocManager](https://github.com/TransparencyToolkit/DocManager) project
  config Harvester should use
* Start Harvester: Run `rails server -p 3333`
* Start Resque: Run `QUEUE=* rake environment resque:work`
* Use Harvester: Go to [http://0.0.0.0:3333](http://0.0.0.0:3333) in your
  browser
