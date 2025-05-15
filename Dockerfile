# Build stage
FROM node:18-alpine AS builder
WORKDIR /app

# Copy and unzip
COPY frontend-artifact-latest.zip . 
RUN apk add --no-cache unzip && unzip frontend-artifact-latest.zip && ls -al

# Inspect and find correct path
# (Assume files are unzipped directly to /app/)
RUN ls -al /app

# Set correct workdir — adjust if it's not `cart-project`
WORKDIR /app

# Ensure package.json is here
RUN ls -al

RUN npm install || { echo 'npm install failed'; exit 1; }
RUN npm run build || { echo 'npm run build failed'; exit 1; }

# Production stage
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
