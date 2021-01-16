#!/usr/bin/env bash

echo "Download the script"
curl -L https://github.com/truongvan/open-distro-on-raspberry-pi/archive/0.0.1.tar.gz -o opendistro.tar.gz

echo "Extract..."
tar -xvf opendistro.tar.gz

cd open-distro-on-raspberry-pi-0.0.1

echo "Install Elasticsearch"
bash opendistroforelasticsearch.sh

echo "Install Kibana"
bash opendistroforelasticsearch-kibana.sh