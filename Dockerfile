FROM node:lts

WORKDIR /home

COPY package.json ./
RUN yarn install --production
COPY index.js ./
COPY build.sh /tmp/build.sh 
RUN /tmp/build.sh

EXPOSE 80
EXPOSE 5004

CMD ["node", "index.js"]
