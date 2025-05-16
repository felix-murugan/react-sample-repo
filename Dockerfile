# Stage 1: Build React App
FROM node:18-alpine AS builder
WORKDIR /app

# Install dependencies required for unzipping
RUN apk add --no-cache unzip

# Copy the artifact ZIP file from the artifact repository into the container
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest.zip /app/frontend-artifact-latest.zip

# Unzip the artifact into the working directory
RUN unzip frontend-artifact-latest.zip -d /app/frontend-artifact-latest

# Move into the React project directory after unzipping
WORKDIR /app/frontend-artifact-latest/cart-project

# Debug: Ensure package.json exists
RUN ls -l /app/frontend-artifact-latest/cart-project/

# Ensure correct file permissions
RUN chown -R node:node /app/frontend-artifact-latest/cart-project

# Install dependencies and build the React app
RUN npm install || { echo 'npm install failed'; exit 1; }
RUN npm run build || { echo 'npm run build failed'; exit 1; }

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Copy built React app to NGINX html directory
COPY --from=builder /app/frontend-artifact-latest/cart-project/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
