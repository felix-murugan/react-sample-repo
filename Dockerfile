FROM node:18

WORKDIR /app

# Copy the React artifact zip
COPY react-artifact-repo/frontend-artifact/latest.zip ./artifact.zip

# Install unzip and serve
RUN apt-get update && apt-get install -y unzip && npm install -g serve

# Unzip and relocate the artifact directory
RUN unzip artifact.zip -d cart-project-clean && \
    CART_DIR=$(find cart-project-clean -mindepth 1 -maxdepth 1 -type d | head -n 1) && \
    echo "Detected project folder: $CART_DIR" && \
    mv "$CART_DIR" cart-project-clean-cleaned

WORKDIR /app/cart-project-clean-cleaned

# Copy only package.json and package-lock.json for better cache and safe partial install
COPY --chown=node:node package*.json ./

# 1. Install esbuild separately
RUN npm install esbuild

# 2. Fix the permissions on esbuild binary
RUN chmod +x node_modules/esbuild/bin/esbuild

# 3. Install remaining dependencies, skipping esbuild since it’s already installed
RUN npm install --omit=dev || true

# Optional build step (safe fallback)
RUN npm run build || echo "Skipping build - maybe already done"

# Serve
WORKDIR /app/cart-project-clean-cleaned/dist
EXPOSE 5173
CMD ["serve", "-s", ".", "-l", "5173"]
