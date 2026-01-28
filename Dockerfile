FROM node:lts

ARG EMBY_VERSION="4.9.3.0"

WORKDIR /home

COPY package.json ./
RUN npm install --omit=dev
COPY index.js ./
COPY build.sh /tmp/build.sh 
RUN /tmp/build.sh "${EMBY_VERSION}"

EXPOSE 80
EXPOSE 5004

CMD ["node", "index.js"]
