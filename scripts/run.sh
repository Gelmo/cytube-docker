#!/bin/sh

envsubst < config.docker.yaml > config.yaml
while :
do
    node index.js
    sleep 2
done
