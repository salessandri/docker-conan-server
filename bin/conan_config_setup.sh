#!/bin/sh

# This script sets up the base server.conf file to be used by the conan server process. It only has
# an effect if there is no server.conf file in /root/.conan_server/.
#
# The options it sets can be tweaked by setting environmental variables when creating the docker
# container.
#

set -e

if [ -e "/root/.conan_server/server.conf" ]; then
    exit 0
fi

mkdir /root/.conan_server/
cp /opt/conan/conan-server.conf.base /root/.conan_server/server.conf

if [ -z "$JWT_SECRET" ]; then
    JWT_SECRET=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 64 | head -n 1)
fi

if [ -z "$UPDOWN_SECRET" ]; then
    UPDOWN_SECRET=$(cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 64 | head -n 1)
fi

AUTHORIZE_TIMEOUT=${AUTHORIZE_TIMEOUT-1800}
PORT=${PORT-9300}
STORAGE_PATH=${STORAGE_PATH-"\\/var\\/conan\\/"}

sed -i -e "s/(JWT_SECRET)/${JWT_SECRET}/g" \
       -e "s/(UPDOWN_SECRET)/${UPDOWN_SECRET}/g" \
       -e "s/(AUTHORIZE_TIMEOUT)/${AUTHORIZE_TIMEOUT}/g" \
       -e "s/(PORT)/${PORT}/g" \
       -e "s/(STORAGE_PATH)/${STORAGE_PATH}/g" \
       /root/.conan_server/server.conf
