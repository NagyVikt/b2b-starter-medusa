
  FROM node:20-bullseye-slim

  # The Medusa build needs Python and build tools for native deps
  RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 build-essential \
    && rm -rf /var/lib/apt/lists/*

  # Yarn 4 ships with Corepack, so just enable it
  RUN corepack enable

  WORKDIR /app

  # Install dependencies based on the existing lockfile
  COPY package.json yarn.lock ./
  RUN yarn install --immutable

  # Copy the rest of the backend sources
  COPY . .

  # Compile the Medusa project (TS -> JS)
  RUN yarn build

  # Runtime configuration
  ENV NODE_ENV=production
  ENV MEDUSA_CONFIG_FILE=./dist/medusa-config.js
  ENV PORT=9000
  EXPOSE 9000

  CMD ["yarn", "start"]
