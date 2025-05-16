# Stage 1: Build React App
FROM node:18-alpine AS builder
WORKDIR /app

# Install unzip tool
RUN apk add --no-cache unzip

# Copy artifact ZIP
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest.zip ./frontend-artifact-latest.zip

# Unzip artifact
RUN unzip frontend-artifact-latest.zip -d ./frontend-artifact-latest

WORKDIR /app/frontend-artifact-latest/cart-project

COPY /frontend-artifact-latest/cart-project/package*.json ./
RUN npm install
# Move into your React project directory
# WORKDIR /app/frontend-artifact-latest/cart-project

# Install dependencies
# RUN npm cache clean --force
# RUN npm install --legacy-peer-deps

# Build React app (Vite uses `vite build` behind the scenes with npm run build)
RUN npm run build

# Stage 2: Serve with NGINX
FROM nginx:alpine

# Copy build output from builder stage
COPY --from=builder /app/frontend-artifact-latest/cart-project/dist /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
# Expose port 80
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]
