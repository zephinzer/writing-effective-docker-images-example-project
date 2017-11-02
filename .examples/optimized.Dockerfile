ARG ALPINE_VERSION=3.6
FROM alpine:${ALPINE_VERSION}
ARG APPLICATION_PATH=/app
ENV APK_ADD="bash curl nodejs nodejs-npm yarn" \
    APK_DEL="bash curl yarn" \
    USERNAME="app" \
    USER_ID="1000"
WORKDIR ${APPLICATION_PATH}
COPY . ${APPLICATION_PATH}
RUN apk update \
    && apk upgrade \
    && apk add --no-cache ${APK_ADD} \
    && yarn install \
    && yarn build \
    && yarn cache clean \
    && rm -rf \
         /usr/share/man/* \
         /usr/includes/* \
         /var/cache/apk/* \
         /root/.npm/* \
         /usr/lib/node_modules/npm/man/* \
         /usr/lib/node_modules/npm/doc/* \
         /usr/lib/node_modules/npm/html/* \
         /usr/lib/node_modules/npm/scripts/* \
    && apk del ${APK_DEL} \
    && adduser -H -D ${USERNAME} -u ${USER_ID} \
    && chown ${USERNAME}:${USERNAME} -R ${APPLICATION_PATH} \
    && deluser --remove-home daemon \
    && deluser --remove-home adm \
    && deluser --remove-home lp \
    && deluser --remove-home sync \
    && deluser --remove-home shutdown \
    && deluser --remove-home halt \
    && deluser --remove-home postmaster \
    && deluser --remove-home cyrus \
    && deluser --remove-home mail \
    && deluser --remove-home news \
    && deluser --remove-home uucp \
    && deluser --remove-home operator \
    && deluser --remove-home man \
    && deluser --remove-home cron \
    && deluser --remove-home ftp \
    && deluser --remove-home sshd \
    && deluser --remove-home at \
    && deluser --remove-home squid \
    && deluser --remove-home xfs \
    && deluser --remove-home games \
    && deluser --remove-home postgres \
    && deluser --remove-home vpopmail \
    && deluser --remove-home ntp \
    && deluser --remove-home smmsp \
    && deluser --remove-home guest
USER app
EXPOSE 3000
VOLUME ["${APPLICATION_PATH}/pages"]
ENTRYPOINT ["npm", "run", "dev"]