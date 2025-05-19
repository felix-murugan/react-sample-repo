# Use Node.js base image
FROM node:18

# Set working directory
WORKDIR /app

# Install 7zip to unzip the artifact
RUN apt-get update && \
    apt-get install -y p7zip-full && \
    rm -rf /var/lib/apt/lists/*

# Copy artifact zip from external repo into container
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest.zip .

# Extract artifact and handle overwriting files
RUN 7z x -aoa frontend-artifact-latest.zip && \
    rm frontend-artifact-latest.zip && \
    echo "=== Extracted files (ls -l) ===" && \
    ls -l && \
    echo "=== Recursive listing (tree substitute using find) ===" && \
    find . -type f

RUN ls -l    

# Optional: Move cart-project if it's nested in a subdirectory
RUN CART_DIR=$(find . -type d -name "cart-project" | head -n 1) && \
    echo "Found cart-project at: $CART_DIR" && \
    mv "$CART_DIR" ./cart-project

# Copy package.json files from extracted folder
COPY cart-project/package*.json ./cart-project/

# Install dependencies
RUN cd cart-project && npm install

# Copy full frontend code
COPY cart-project/ ./cart-project/

# Change working directory to the React project
WORKDIR /app/cart-project

# Expose Vite dev port
EXPOSE 5173

# Run Vite dev server
CMD ["npm", "run", "dev"]
