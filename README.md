Harvester
=========

Web interface and tool to call various web and data crawlers via [CrawlerManager](https://github.com/TransparencyToolkit/CrawlerManager), using mongodb for persistence and loading documents to [LookingGlass](https://github.com/TransparencyToolkit/LookingGlass).

Harvester depends on:
- [LookingGlass](https://github.com/TransparencyToolkit/LookingGlass) a web interface to search, filter, and browse any JSON data. Includes full text, categorical data and search interface with elasticsearch backend.
- [CrawlerManager](https://github.com/TransparencyToolkit/CrawlerManager) an API for running and managing crawlers

## Installing

Make sure you have the proper system dependencies with

- Intall Ruby on Rails
- On Debian, install depedencies:
  - `sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmagickcore-dev libmagickwand-dev mongodb`
- Get the Harvester code `git clone https://github.com/TransparencyToolkit/Harvester`
- Install Ruby dependencies from `cd Harvester` and then `bundle install`
- Download and install [CrawlerManager](https://github.com/TransparencyToolkit/CrawlerManager)
- Download & install [LookingGlass](https://github.com/TransparencyToolkit/LookingGlass) and it's depedencies


### Install Tika & Tesseract (optional)

By default document conversion (pdf, docs, etc..) is handled by [GiveMeText](http://givemetext.okfnlabs.org), this approach sends your documents over the clear internet. 
*DO NOT USE THIS* with sensitive documents, instead install Tika & Tesseract.

- Install java package manager `apt-get install default-jdk maven unzip`
- Download `Tika` from github and unzip it

```
mkdir install
curl https://codeload.github.com/apache/tika/zip/trunk -o trunk.zip
unzip trunk.zip
```

- Go into the `tika-trunk` direcoty created during the last step & install

```
cd tika-trunk
mvn -DskipTests=true clean install
cp tika-server/target/tika-server-1.*-SNAPSHOT.jar /srv/tika-server-1.*-SNAPSHOT.jar
```

- Now install `Tesseract` with the following

```
apt-get -y -q install tesseract-ocr tesseract-ocr-deu tesseract-ocr-eng
```

---


## Running Everything


**Start CrawlerManager**

1. Start `CrawlerManager` in that directory `rails server -p 9506`

**Start Tika**

1. Start `Tika` with `java -jar tika-server/target/tika-server-*.jar` 
2. If you need Tika to have custom URL or port  `--host=localhost --port=1234`

**Start Harvester**

1. Make sure mongodb is running on your system with mongod --dbpath /path/to/data
2. Run QUEUE=* rake environment resque:work. To monitor resque with the web interface, also run resque-web
3. Then run Harvester with `rails server -p 3333`
4. Go to [0.0.0.0:3000](http://0.0.0.0:3333) in a browser

**Start LookingGlass**

1. Start `elasticsearch` as it was installed on your server
2. Start `LookingGlass` from that directory `rails server`

**Add CAPTCHA Solving**

Crawling some sites using tools like Tor or VPNs sometimes require solving of
CAPTCHA's, Harvester can support this you just need to do the following:

..........To be filled out..................
