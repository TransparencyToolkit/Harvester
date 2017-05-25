FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libcurl3 libcurl3-gnutls libcurl4-openssl-dev libmagickcore-dev libmagickwand-dev mongodb
RUN mkdir /harvester
WORKDIR /harvester
ADD * /harvester/
RUN bundle install
ADD . /harvester