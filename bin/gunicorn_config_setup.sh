#!/bin/sh

# This script sets up the base server.conf file to be used by the gunicorn server. It only has
# an effect if there is no gunicorn.conf.py file in /root/.conan_server/.
#
# The options it sets can be tweaked by setting environmental variables when creating the docker
# container.
#

set -e

if [ -e "/root/.conan_server/gunicorn.conf.py" ]; then
    exit 0
fi

cp "/opt/conan/gunicorn.conf.py.base" "/root/.conan_server/gunicorn.conf.py"

PORT=${PORT-9300}
WORKERS=${WORKERS-4}
TIMEOUT=${TIMEOUT-30}

sed -i -e "s/(PORT)/${PORT}/g" \
       -e "s/(WORKERS)/${WORKERS}/g" \
       -e "s/(TIMEOUT)/${TIMEOUT}/g" \
       "/root/.conan_server/gunicorn.conf.py"
