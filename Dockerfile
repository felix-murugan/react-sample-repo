# Stage 1: Build React App
FROM node:18-alpine AS builder
WORKDIR /app

# Install unzip for extracting the artifact
RUN apk add --no-cache unzip

# Copy the React artifact ZIP into the container
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest.zip /app/frontend-artifact-latest.zip

# Unzip the artifact
RUN unzip frontend-artifact-latest.zip -d /app/frontend-artifact-latest

# Move into the React project directory
WORKDIR /app/frontend-artifact-latest/cart-project/

# Debug: List files to ensure package.json is present
RUN ls -al

# Set correct permissions (optional but good practice)
RUN chown -R node:node .

# Install dependencies (with legacy-peer-deps to avoid React peer issues)
RUN npm cache clean --force && npm install --legacy-peer-deps || (echo "npm install failed" && exit 1)

# Build the React app
RUN npm run build || (echo "npm build failed" && exit 1)

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Copy built app to NGINX default public directory
COPY --from=builder /app/frontend-artifact-latest/cart-project/dist /usr/share/nginx/html

# Expose the default port
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
