# Stage 1: Build React App
FROM node:18-alpine AS builder
WORKDIR /app

# Copy and unzip artifact
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest.zip
RUN apk add --no-cache unzip && unzip frontend-artifact-latest.zip

# Change into the React app directory
WORKDIR /app/cart-project

# Install dependencies and build the app
RUN npm install || { echo 'npm install failed'; exit 1; }
RUN npm run build || { echo 'npm run build failed'; exit 1; }

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Copy built React app to NGINX html directory
COPY --from=builder /app/cart-project/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Run NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
