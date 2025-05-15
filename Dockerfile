# Stage 1: Build React App
FROM node:18-alpine AS builder
WORKDIR /app

# Install unzip and extract artifact, then remove unzip to reduce image size
RUN apk add --no-cache unzip
COPY frontend-artifact.zip .
RUN unzip frontend-artifact.zip && rm frontend-artifact.zip

# Change into React app folder inside the extracted zip (adjust if needed)
WORKDIR /app/cart-project

# Install dependencies and build app
RUN npm install || { echo 'npm install failed'; exit 1; }
RUN npm run build || { echo 'npm run build failed'; exit 1; }

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Copy built React app to nginx html directory
COPY --from=builder /app/cart-project/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
