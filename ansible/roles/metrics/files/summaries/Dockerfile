FROM node:14-slim@sha256:198142146b4c47193348f6415da769bdb5035c16fcab051c38c256a6b48f2e1c

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . ./

CMD ["npm", "run", "produceSummaries"]
