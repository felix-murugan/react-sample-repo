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

# # Extract and clean up
# RUN 7z x frontend-artifact-latest.zip && \
#     rm frontend-artifact-latest.zip && \
#     echo "=== Extracted contents ===" && ls -la
RUN 7z x frontend-artifact-latest.zip && \
    rm frontend-artifact-latest.zip && \
    echo "=== Extracted files (ls -l) ===" && \
    ls -l && \
    echo "=== Recursive listing (tree substitute using find) ===" && \
    find . -type f

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
