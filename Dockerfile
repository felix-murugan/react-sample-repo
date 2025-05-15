# Stage 1: Build React App
FROM node:18-alpine AS builder
WORKDIR /app

# Copy and unzip artifact
COPY frontend-artifact-latest.zip . 
RUN apk add --no-cache unzip && unzip frontend-artifact-latest.zip && ls -al && ls -al cart-project || true

# Set working directory to project
WORKDIR /app/cart-project

# Show contents before install
RUN ls -al

# Try installing dependencies and print error output
RUN npm install || { echo 'npm install failed'; cat npm-debug.log || true; exit 1; }
RUN npm run build || { echo 'npm run build failed'; exit 1; }

# Stage 2: Serve with NGINX
FROM nginx:alpine
COPY --from=builder /app/cart-project/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
