#!/usr/bin/env bash
# ref: https://opendistro.github.io/for-elasticsearch-docs/

HOME_DIR=$(pwd)
KIBANA_HOME=/usr/local/opendistro/opendistroforelasticsearch-kibana

if [ ! -d /usr/local/opendistro ]; then
  sudo mkdir -p /usr/local/opendistro;
  sudo chown pi:pi /usr/local/opendistro;
fi

cd /usr/local/opendistro/

curl https://d3g5vo6xdbdb9a.cloudfront.net/tarball/opendistroforelasticsearch-kibana/opendistroforelasticsearch-kibana-1.12.0.tar.gz -o opendistroforelasticsearch-kibana-1.12.0.tar.gz
curl https://d3g5vo6xdbdb9a.cloudfront.net/tarball/opendistroforelasticsearch-kibana/opendistroforelasticsearch-kibana-1.12.0.tar.gz.sha512 -o opendistroforelasticsearch-kibana-1.12.0.tar.gz.sha512

if [[ ! `shasum -a 512 -c opendistroforelasticsearch-kibana-1.12.0.tar.gz.sha512` == "opendistroforelasticsearch-kibana-1.12.0.tar.gz: OK" ]]; then 
    echo "checksum does not Verify."
    exit 1
fi

tar -zxf opendistroforelasticsearch-kibana-1.12.0.tar.gz
cd opendistroforelasticsearch-kibana

# Install new node for raspberry pi
rm -rf node
curl https://nodejs.org/dist/v10.22.1/node-v10.22.1-linux-armv7l.tar.xz -o node-v10.22.1-linux-armv7l.tar.xz
tar -xf node-v10.22.1-linux-armv7l.tar.xz
mv node-v10.22.1-linux-armv7l node

echo "Create user kibana"
sudo useradd --system --no-create-home kibana

echo "Copy systemd service"
sudo cp $HOME_DIR/kibana.service /usr/lib/systemd/system/

echo "Change all related folders"
sudo chown -R kibana:kibana $KIBANA_HOME

echo "Setup done"

echo "To start Open Distro for Elasticsearch"
echo "sudo systemctl start kibana.service"

echo "To run Open Distro for Elasticsearch when the system starts:"
echo "sudo /bin/systemctl daemon-reload"
echo "sudo /bin/systemctl enable kibana.service"