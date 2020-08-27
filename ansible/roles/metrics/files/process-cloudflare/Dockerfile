FROM node:12-slim

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . ./

CMD ["npm", "run", "processLogs"]
