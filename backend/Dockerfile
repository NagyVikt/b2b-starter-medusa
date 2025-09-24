FROM node:20-alpine

# Enable corepack (ships with Node >=16.9)
RUN corepack enable

WORKDIR /app

# Copy manifests first for caching
COPY package.json yarn.lock ./

# Install deps with Yarn 4
RUN yarn install --immutable

# Copy rest of the code
COPY . .

# Build (if you have a build step)
RUN yarn build || true

ENV NODE_ENV=production
ENV PORT=9000

EXPOSE 9000

CMD ["yarn", "start"]
