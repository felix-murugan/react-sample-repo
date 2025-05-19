# Use Node.js base image
FROM node:18

# Set working directory
WORKDIR /app

# Install 7zip
RUN apt-get update && \
    apt-get install -y p7zip-full && \
    rm -rf /var/lib/apt/lists/*

# Copy artifact zip
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest.zip .

# Extract it
RUN 7z x -aoa frontend-artifact-latest.zip && rm frontend-artifact-latest.zip

# (Optional) Confirm cart-project exists
RUN ls -la ./cart-project

# Continue with build
WORKDIR /app/cart-project
RUN npm install
RUN npm run build

RUN npm install -g serve
WORKDIR /app/cart-project/dist
EXPOSE 5173
CMD ["serve", "-s", ".", "-l", "5173"]
