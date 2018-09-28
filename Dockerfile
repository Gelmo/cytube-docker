FROM bianjp/mariadb-alpine:latest

ENV MYSQL_HOST=localhost \
	MYSQL_PORT=3306 \
	MYSQL_DATABASE=cytube3 \
	MYSQL_USER=cytube3 \
	MYSQL_PASSWORD=UltraSecretPass \
	MYSQL_ROOT_PASSWORD=UltraSecretRootPass \
	HTTP_PORT=8080 \
	HTTP=true \
	HTTPS_PORT=8443	\
	HTTPS=false \
	IO=true \
	IO_PORT=1337 \
	IO_DOMAIN=http://localhost \
	ROOT_DOMAIN=localhost \
	USE_MINIFY=false \
	COOKIE_SECRET=change-me \
	SYNC_CRTKEY=null \
	SYNC_CRT=null \
	SYNC_CRTCA=null \
	SYNC_TITLE=Sync \
	SYNC_DESCRIPTION="Free, open source synchtube" \
	YOUTUBE_KEY=null \
	CHANNEL_STORAGE=file \
	VIMEO_WORKAROUND=false \
	TWITCH_ID=null \
	MIXER_ID=null

ADD scripts /scripts

RUN sh /scripts/container-install.sh

WORKDIR /home/cytube/app

EXPOSE 8080 1337

CMD ["sh", "run.sh"]
