# Stage 1: Build React App
FROM node:18-alpine AS builder
WORKDIR /app

# Copy and unzip artifact
COPY frontend-artifact-latest.zip .
RUN apk add --no-cache unzip && unzip frontend-artifact-latest.zip

# Go into the cart-project directory
WORKDIR /app/cart-project

# Install dependencies and build
RUN npm install && npm run build

# Stage 2: Serve with NGINX
FROM nginx:alpine
COPY --from=builder /app/cart-project/dist /usr/share/nginx/html

# Expose port
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
