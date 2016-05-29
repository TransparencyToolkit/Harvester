DocumentLoader
==============

Web interface and tool to calls various web and data scrawlers!

## Installing

Make sure you have the proper system dependencies with

- Install [neo4j](http://debian.neo4j.org)
- Intall Ruby on Rails
- On Debian, install depedencies:
  - `sudo apt-get install libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmagickcore-dev libmagickwand-dev`
- Get the DocumentLoader code `git clone https://github.com/TransparencyToolkit/DocumentLoader`
- Install Ruby dependencies from `cd DocumentLoader` and then `bundle install`
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


**Start DocumentLoader**

*Note: make sure that neo4j is not running when starting DocumentLoader*

1. Start `CrawlerManager` in that directory `rails server -p 9506`

**Start Tika**

1. Start `Tika` with `java -jar tika-server/target/tika-server-*.jar` 
2. If you need Tika to have custom URL or port  `--host=localhost --port=1234`

**Start Harvester**

1. Start neo4j `rake neo4j:start`
2. Then run Harvester with `rails server -p 3333`
3. Go to [0.0.0.0:3000](http://0.0.0.0:3333) in a browser

**Start LookingGlass**

1. Start `elasticsearch` as it was installed on your server
2. Start `LookingGlass` from that directory `rails server`

**Add CAPTCHA Solving**

Crawling some sites using tools like Tor or VPNs sometimes require solving of
CAPTCHA's, Harvester can support this you just need to do the following:

..........To be filled out..................

## Shutting Down

*When your done running DocumentLoader*

1. From within the `Harvester` repo, stop neo4j with `rake neo4j:stop`
