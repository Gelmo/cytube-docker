#!/bin/sh

set -e

apt update
apt install -y curl
curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt update
apt install -y build-essential python git nodejs gettext ffmpeg gosu

npm install npm@latest -g

groupadd -r cytube && useradd -r -g cytube cytube

git clone -b 3.0 https://github.com/calzoneman/sync /home/cytube/app
mkdir -p /home/cytube/certs
cd /home/cytube/app
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

gosu cytube npm install
gosu cytube npm run build-server
