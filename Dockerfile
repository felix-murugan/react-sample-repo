FROM node:18

# Set working directory
WORKDIR /app

# Copy the React artifact zip file
# COPY Frontend_Artifact-latest.zip ./artifact.zip
COPY artifact.zip ./artifact.zip


# Install unzip and serve
RUN apt-get update && apt-get install -y unzip && npm install -g serve

# Unzip artifact into a known directory name
RUN unzip artifact.zip -d cart-project-clean \
 && mv $(find cart-project-clean -mindepth 1 -maxdepth 1 -type d | head -n 1) cart-project-clean-cleaned

# Change working directory to the cleaned project
WORKDIR /app/cart-project-clean-cleaned

# Copy package.json and package-lock.json to allow dependency handling (optional, depends on artifact content)
COPY package*.json ./

# Install esbuild and fix permissions
RUN npm install esbuild \
 && chmod +x node_modules/esbuild/bin/esbuild

# Install remaining dependencies (skip dev)
RUN npm install --omit=dev || true

# Run build if needed (optional)
RUN npm run build || echo "Build already done or not needed"

# Serve the app from dist directory
WORKDIR /app/cart-project-clean-cleaned/dist
EXPOSE 5173
CMD ["serve", "-s", "."]
