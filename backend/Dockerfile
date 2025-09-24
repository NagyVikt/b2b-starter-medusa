FROM node:20-alpine
RUN corepack enable

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --immutable

COPY . .

RUN yarn build

ENV NODE_ENV=production
ENV PORT=9000
# 👇 Add this line
ENV MEDUSA_CONFIG_FILE=./dist/medusa-config.js

EXPOSE 9000
CMD ["yarn", "start"]
