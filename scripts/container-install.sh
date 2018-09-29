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

mysqld_safe &

echo "DELETE FROM mysql.user WHERE User='';" >> /tmp/sql
echo "GRANT USAGE ON *.* TO ${MYSQL_USER}@'127.0.0.1' IDENTIFIED BY '${MYSQL_PASSWORD}';" > /tmp/sql
echo "GRANT USAGE ON *.* TO ${MYSQL_USER}@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> /tmp/sql
echo "GRANT USAGE ON *.* TO ${MYSQL_USER}@'::1' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> /tmp/sql
echo "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO ${MYSQL_USER}@'127.0.0.1' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> /tmp/sql
echo "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO ${MYSQL_USER}@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> /tmp/sql
echo "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO ${MYSQL_USER}@'::1' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> /tmp/sql
echo "CREATE DATABASE ${MYSQL_DATABASE};" >> /tmp/sql
echo "FLUSH PRIVILEGES;" >> /tmp/sql
cat /tmp/sql | mysql -u root --password="${MYSQL_ROOT_PASSWORD}"

su-exec cytube npm install
su-exec cytube npm run build-server
