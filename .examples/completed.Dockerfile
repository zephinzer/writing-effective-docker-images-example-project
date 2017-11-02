ARG ALPINE_VERSION=3.6
FROM alpine:${ALPINE_VERSION}
RUN apk update
RUN apk upgrade
ARG APPLICATION_PATH=/app
ENV APK_ADD="bash curl nodejs nodejs-npm yarn"
ENV APK_DEL="bash curl yarn"
ENV USERNAME="app"
ENV USER_ID="1000"
RUN apk add --no-cache ${APK_ADD}
WORKDIR ${APPLICATION_PATH}
COPY . ${APPLICATION_PATH}
RUN yarn install
RUN yarn build
RUN yarn cache clean
RUN rm -rf \
      /usr/share/man/* \
      /usr/includes/* \
      /var/cache/apk/* \
      /root/.npm/* \
      /usr/lib/node_modules/npm/man/* \
      /usr/lib/node_modules/npm/doc/* \
      /usr/lib/node_modules/npm/html/* \
      /usr/lib/node_modules/npm/scripts/*
RUN apk del ${APK_DEL}
RUN adduser -H -D ${USERNAME} -u ${USER_ID}
RUN chown ${USERNAME}:${USERNAME} -R ${APPLICATION_PATH}
RUN deluser --remove-home daemon
RUN deluser --remove-home adm
RUN deluser --remove-home lp
RUN deluser --remove-home sync
RUN deluser --remove-home shutdown
RUN deluser --remove-home halt
RUN deluser --remove-home postmaster
RUN deluser --remove-home cyrus
RUN deluser --remove-home mail
RUN deluser --remove-home news
RUN deluser --remove-home uucp
RUN deluser --remove-home operator
RUN deluser --remove-home man
RUN deluser --remove-home cron
RUN deluser --remove-home ftp
RUN deluser --remove-home sshd
RUN deluser --remove-home at
RUN deluser --remove-home squid
RUN deluser --remove-home xfs
RUN deluser --remove-home games
RUN deluser --remove-home postgres
RUN deluser --remove-home vpopmail
RUN deluser --remove-home ntp
RUN deluser --remove-home smmsp
RUN deluser --remove-home guest
USER app
EXPOSE 3000
VOLUME ["${APPLICATION_PATH}/pages"]
ENTRYPOINT ["npm", "run", "dev"]