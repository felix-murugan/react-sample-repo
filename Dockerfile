# Use official Node image
FROM node:18

# Set working directory
WORKDIR /app

# Install 7zip to extract the artifact
RUN apt-get update && \
    apt-get install -y p7zip-full && \
    rm -rf /var/lib/apt/lists/*

# Copy the zipped artifact (from your GitHub checkout)
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest.zip .

# Extract the zipped artifact
RUN 7z x -aoa frontend-artifact-latest.zip && rm frontend-artifact-latest.zip

# Set working directory to extracted project
WORKDIR /app/cart-project-clean

# Install dependencies freshly
RUN npm install

# Optional: Build again (or skip if dist/ already included)
# RUN npm run build

# Install serve to run static build
RUN npm install -g serve

# Serve build output
WORKDIR /app/cart-project-clean/dist
EXPOSE 5173
CMD ["serve", "-s", ".", "-l", "5173"]
