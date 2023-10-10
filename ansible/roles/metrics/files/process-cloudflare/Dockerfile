FROM node:15-slim@sha256:ecfa754d007a069a2ffc293115927f86416beea07b779c48c0597e26d2321bbb

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . ./

CMD ["npm", "run", "processLogs"]
