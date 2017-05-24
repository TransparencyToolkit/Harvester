This is a backend for Transparency Toolkit's other tools (LookingGlass,
Harvester, Catalyst). It indexes data, stores the documents, and processes
queries all in one place. All the specifications for what data sources are
available and what fields they have are also handled by DocManager.

# Installation

## Dependencies

* elasticsearch 5.4.0
* ruby 2.4.1
* rails 5
* mongodb

## Setup Instructions

1. Install the dependencies

* Download elasticsearch (https://www.elastic.co/downloads/elasticsearch)
* Download rvm (https://rvm.io/rvm/install)
* rvm install 2.4.1 and rvm use 2.4.1
* gem install rails
* bundle install

2. Run

* Start elasticsearch (exact method depends on installation method)
* Create a directory for the mongodb database
* mongod --dbpath dirname/
* rails server

3. Testing and Similar

* Run Tests: bundle exec rspec
* Look at DB: mongo doc_manager_development


# Software and Config File Structure

## Project and Data Source Configuration Files

Configuration files for data sources and projects are stored in the
dataspec_files directory. This has three directories with three types of
sub-files-
* projects: A project is a collection of all data on a particular topic (or
that you want stored in the same elasticsearch index). It is only possible to
access one project at a time, but you can switch between multiple
projects. Each project can have multiple data sources. The configuration files
specifying what data sources a project includes, what it is called, etc. are
in the projects directory.
* data_sources: Each data source needs a config file to specify what fields it
has, where each should show up on the various apps, it's name, etc. The
correct data source file is automatically loaded into the other apps when
needed and all supported data sources have pre-written config files.
* fields_for_all_sources: These config files specify what fields every data
source has, such as those Harvester uses for managing versions and
threads. The fields in this directory will be loaded into every data source
automatically.

These files are automatically loaded into DocManager and used by the apps that
query it. But the specific project you want to access/use may need to be set
in configuration options in the other apps.


## Code Outline

The code is divided into the following components:
* analyzers: Config files that elasticsearch uses to determine how it should
index data in various languages.
* controllers: Handle incoming requests to the API. These don't have much
content themselves, but mostly include other functions for managing indexing,
queries, and dataspecs.
* dataspec: Load in the project and data source config files, generate models
for new data sources using metaprogramming, and retrieves the appropriate
source and project objects when requested.
* index: Indexes the data in elasticsearch, including preprocessing tasks like
setting a unique ID (that is consistent across reindexes), tracking different
versions of the same data, handling different formats of date fields, and
generally managing messy data. Also handles data deletion.
* models: Specify the fields that should be saved in mongodb for projects and
data sources. Most of the management and creation of these sources is
initially handled in the modules in the dataspec directory.
* queries: Process and run elasticsearch queries. Includes everything from
getting the documents to load and showing the total number to actual search
queries.
