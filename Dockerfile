FROM node:lts

ARG EMBY_VERSION="4.9.3.0"

WORKDIR /home

COPY build.sh emby*.deb /tmp/
RUN /tmp/build.sh "${EMBY_VERSION}"

COPY package.json ./
RUN npm install --omit=dev
COPY index.js ./

EXPOSE 80
EXPOSE 5004

CMD ["node", "index.js"]
