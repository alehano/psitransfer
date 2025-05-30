FROM node:20-alpine

ENV PSITRANSFER_UPLOAD_DIR=/data \
    NODE_ENV=production

MAINTAINER Christoph Wiechert <wio@psitrax.de>

RUN apk add --no-cache tzdata

WORKDIR /app

ADD *.js package.json yarn.lock README.md /app/
ADD lib /app/lib
ADD app /app/app
ADD lang /app/lang
ADD plugins /app/plugins
ADD public /app/public

# Rebuild the frontend apps
RUN cd app && \
    NODE_ENV=dev yarn install --frozen-lockfile && \
    yarn run build && \
    cd .. && \
    mkdir /data && \
    chown node /data && \
    yarn install --frozen-lockfile && \
    rm -rf app

EXPOSE 3000
VOLUME ["/data"]

USER node

# HEALTHCHECK CMD wget -O /dev/null -q http://localhost:3000

CMD ["node", "app.js"]
