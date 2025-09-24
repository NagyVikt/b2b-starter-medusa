# Development Dockerfile for Medusa
FROM node:20-alpine

# Set working directory
WORKDIR /server

# Enable corepack and prepare Yarn 4.4.0
RUN corepack enable && corepack prepare yarn@4.4.0 --activate

# Copy package files and yarn config first (for better caching)
COPY package.json yarn.lock .yarnrc.yml ./

# Install all dependencies using yarn
RUN yarn install

# Copy the rest of the source code
COPY . .

# Expose the port Medusa runs on
EXPOSE 9000

# Start with migrations and then the development server
CMD ["./start.sh"]
