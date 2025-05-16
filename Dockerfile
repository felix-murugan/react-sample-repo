# Stage 1: Build React App
FROM node:18-alpine AS builder
WORKDIR /app

# Install dependencies required for unzipping
RUN apk add --no-cache unzip

# Copy the React artifact ZIP into the container
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest.zip /app/frontend-artifact-latest.zip

# Unzip the artifact
RUN unzip frontend-artifact-latest.zip -d /app/frontend-artifact-latest

# Debug: Check extracted files
RUN ls -l /app/frontend-artifact-latest/

# Move into the React project directory
WORKDIR /app/frontend-artifact-latest/cart-project/

# Copy package.json and package-lock.json correctly
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest/cart-project/package*.json ./

# Install dependencies
RUN npm cache clean --force
RUN npm install --legacy-peer-deps || { echo 'npm install failed'; exit 1; }

# Copy the source code correctly
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest/cart-project/ ./

# Build the app
RUN npm run build || { echo 'npm run build failed'; exit 1; }

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Copy built app to NGINX default public directory
COPY --from=builder /app/frontend-artifact-latest/cart-project/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start the web server
CMD ["nginx", "-g", "daemon off;"]
