#!/bin/sh

set -e

apk update
apk add build-base python git nodejs nodejs-npm curl gettext ffmpeg
npm install npm@latest -g

git clone https://github.com/calzoneman/sync /app

cd /app
cp -f /scripts/config.docker.yaml /app
cp -f /scripts/run.sh /app

npm install
npm run build-server
