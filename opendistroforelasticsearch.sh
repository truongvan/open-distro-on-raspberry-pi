#!/usr/bin/env bash
# ref: https://opendistro.github.io/for-elasticsearch-docs/

HOME_DIR=$(pwd)
ES_HOME=/usr/local/opendistro/opendistroforelasticsearch-1.12.0

if [ ! -d /usr/local/opendistro ]; then
  sudo mkdir -p /usr/local/opendistro;
  sudo chown pi:pi /usr/local/opendistro
fi

cd /usr/local/opendistro/

curl https://d3g5vo6xdbdb9a.cloudfront.net/tarball/opendistro-elasticsearch/opendistroforelasticsearch-1.12.0.tar.gz -o opendistroforelasticsearch-1.12.0.tar.gz
curl https://d3g5vo6xdbdb9a.cloudfront.net/tarball/opendistro-elasticsearch/opendistroforelasticsearch-1.12.0.tar.gz.sha512 -o opendistroforelasticsearch-1.12.0.tar.gz.sha512
if [[ ! `shasum -a 512 -c opendistroforelasticsearch-1.12.0.tar.gz.sha512` == "opendistroforelasticsearch-1.12.0.tar.gz: OK" ]]; then 
    echo "checksum does not Verify."
    exit 1
fi
tar -zxf opendistroforelasticsearch-1.12.0.tar.gz
cd opendistroforelasticsearch-1.12.0

echo "Remove knn plugin, do not work on Raspberry Pi"
rm -rf $ES_HOME/plugins/opendistro-knn

echo "Install openjdk-11"
rm -rf $ES_HOME/jdk
sudo apt-get install openjdk-11-jdk -y

echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf

echo "Change elasticsearch data to /var/lib/elasticsearch"
echo "path.data: /var/lib/elasticsearch" | tee -a $ES_HOME/config/elasticsearch.yml

echo "Change elasticsearch log to /var/log/elasticsearch"
echo "path.logs: /var/log/elasticsearch" | tee -a $ES_HOME/config/elasticsearch.yml

echo "Copy systemd service"
sudo cp $HOME_DIR/elasticsearch.service /usr/lib/systemd/system/
sudo cp $HOME_DIR/elasticsearch /etc/default/

echo "Create data and log folders"
sudo mkdir /var/lib/elasticsearch
sudo mkdir /var/log/elasticsearch

echo "Create user elasticsearch"
sudo useradd --system --no-create-home elasticsearch

echo "Change all related folders"
sudo chown -R elasticsearch:elasticsearch $ES_HOME
sudo chown -R elasticsearch:elasticsearch /var/lib/elasticsearch

echo "Run install script by opendistro"
sudo cp $HOME_DIR/adapted-opendistro-install.sh $ES_HOME/
cd $ES_HOME
sudo su elasticsearch -c "bash adapted-opendistro-install.sh"

echo "Setup all done"
echo "To start Open Distro for Elasticsearch"
echo "sudo systemctl start elasticsearch.service"

echo "To run Open Distro for Elasticsearch when the system starts:"
echo "sudo /bin/systemctl daemon-reload"
echo "sudo /bin/systemctl enable elasticsearch.service"