 # backend/Dockerfile
  FROM node:20-alpine

  # Required shared libs when running on Alpine (musl)
  RUN apk add --no-cache python3 make g++ libc6-compat

  # Ensure Yarn 4 is available
  RUN corepack enable

  WORKDIR /app
  ENV NODE_ENV=production

  # Install the dependencies that are already in the lockfile
  COPY package.json yarn.lock ./
  RUN yarn install --immutable

  # Add the musl build of SWC so ts-node / Medusa CLI can load it on Alpine
  RUN yarn add -D @swc/core-linux-x64-musl

  # Bring in the rest of the backend source
  COPY . .

  # Build the backend (TS → JS)
  RUN yarn build

  # Point Medusa at the compiled config and expose the default port
  ENV MEDUSA_CONFIG_FILE=./dist/medusa-config.js
  ENV PORT=9000
  EXPOSE 9000

  CMD ["yarn", "start"]
