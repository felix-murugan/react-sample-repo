# Use Node base image
FROM node:18

# Set working directory
WORKDIR /app

# Install p7zip to unzip the file
RUN apt-get update && \
    apt-get install -y p7zip-full && \
    rm -rf /var/lib/apt/lists/*

# Copy the zip artifact into the container
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest.zip ./

# Extract and clean up the zip, and confirm structure
RUN 7z x frontend-artifact-latest.zip && \
    rm frontend-artifact-latest.zip && \
    echo "=== Extracted contents ===" && ls -la

# Copy package files and install dependencies
COPY cart-project/package*.json ./
RUN npm install

# Copy the rest of the frontend code
COPY cart-project/ ./

# Expose React development server port
EXPOSE 3000

# Start the React app
CMD ["npm", "run", "dev"]
