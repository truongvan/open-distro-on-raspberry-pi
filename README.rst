Open Distro for Elasticsearch on Raspberry Pi
==============================================

Installing and running Open Distro for Elasticsearch on Raspberry Pi
- Remove knn plugins (does not work on Raspberry Pi)
- Install to `/usr/local/opendistro`
- Data folder is moved to `/var/lib/elasticsearch`


Install
-------

Copy script to Raspberry Pi::

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/truongvan/open-distro-on-raspberry-pi/main/install.sh)"


Using
-----

Run with system start
~~~~~~~~~~~~~~~~~~~~~
::

    sudo /bin/systemctl daemon-reload
    sudo systemctl enable elasticsearch
    sudo systemctl enable kibana

Start
~~~~~
::

    sudo systemctl start elasticsearch
    sudo systemctl start kibana

Check status
~~~~~~~~~~~~
::

    sudo systemctl status elasticsearch
    sudo systemctl status kibana