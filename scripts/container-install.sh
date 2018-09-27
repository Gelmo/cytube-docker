#!/bin/sh

set -e

apk update
apk add build-base python git nodejs nodejs-npm curl gettext ffmpeg su-exec pcre-dev

npm install npm@latest -g

adduser -S cytube


git clone -b 3.0 https://github.com/calzoneman/sync /home/cytube/app
mkdir -p /home/cytube/certs
cd /home/cytube/app
sed 's/67c7c69a/ffdbce83/' package.json
cp -f /scripts/config.docker.yaml /home/cytube/app
cp -f /scripts/run.sh /home/cytube/app
chown -R cytube /home/cytube

su-exec cytube npm install

