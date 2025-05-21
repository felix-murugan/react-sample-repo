# Base image
FROM node:18

# Create app directory
WORKDIR /app

# Install unzip tool
RUN apt-get update && apt-get install -y p7zip-full curl && rm -rf /var/lib/apt/lists/*

# Download the frontend artifact ZIP file from GitHub
RUN curl -L -o frontend-artifact-latest.zip https://raw.githubusercontent.com/felix-murugan/react-artifact-repo/main/frontend-artifact/frontend-artifact-latest.zip

# Confirm it's a ZIP file (for debugging)
RUN file frontend-artifact-latest.zip

# Extract the ZIP file
RUN 7z x frontend-artifact-latest.zip && rm frontend-artifact-latest.zip

# Move into the extracted project directory
# If the extracted folder is named something specific, update this path
WORKDIR /app/cart-project

# Install dependencies
RUN npm install

# Expose port (default for Vite)
EXPOSE 5173

# Start the React app
CMD ["npm", "run", "dev"]
