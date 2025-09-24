FROM node:20-alpine

# Enable Yarn via Corepack
RUN corepack enable

# Create workdir
WORKDIR /app

# Install dependencies only when needed
COPY package.json yarn.lock ./
RUN yarn install --immutable

# Copy rest of project
COPY . .

# Build TypeScript → JavaScript
RUN yarn build

# Point Medusa at the compiled config
ENV MEDUSA_CONFIG_FILE=./dist/medusa-config.js

# Runtime environment
ENV NODE_ENV=production
ENV PORT=9000

EXPOSE 9000

# Start Medusa
CMD ["yarn", "start"]
