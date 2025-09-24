FROM node:20-alpine

# Create app directory
WORKDIR /app

# Install dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy rest of the code
COPY . .

# Build (if your Medusa project has a build step)
RUN yarn build || true

# Env vars
ENV NODE_ENV=production
ENV PORT=9000

# Expose Medusa port
EXPOSE 9000

# Start the backend
CMD ["yarn", "start"]
