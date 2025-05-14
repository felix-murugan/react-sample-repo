# Stage 1: Build React App
FROM node:18-alpine AS builder
WORKDIR /app

# Copy and unzip artifact
COPY frontend-artifact-latest.zip . 
RUN apk add --no-cache unzip && unzip frontend-artifact-latest.zip

# Go into the cart-project directory
WORKDIR /app/cart-project

# Copy package.json and package-lock.json before installing dependencies
COPY cart-project/package.json cart-project/package-lock.json ./cart-project/

# Install dependencies and build the app
RUN npm install || { echo 'npm install failed'; exit 1; }
RUN npm run build || { echo 'npm run build failed'; exit 1; }

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Copy the built React app into NGINX's public directory
COPY --from=builder /app/cart-project/dist /usr/share/nginx/html

# Expose port 80 for the NGINX server
EXPOSE 80

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
