#!/bin/sh
set -e

conan_config_setup.sh

gunicorn_config_setup.sh

echo "##############################################################"
echo "# Conan Configuration used: /root/.conan_server/server.conf  #"
echo "##############################################################"
echo ""
cat /root/.conan_server/server.conf
echo ""
echo "##############################################################"
echo ""
echo ""
echo ""
echo "######################################################################"
echo "# Gunicorn Configuration used: /root/.conan_server/gunicorn.conf.py  #"
echo "######################################################################"
echo ""
cat /root/.conan_server/gunicorn.conf.py
echo ""
echo "######################################################################"

exec gunicorn "--config" "/root/.conan_server/gunicorn.conf.py" "conans.server.server_launcher:app"
