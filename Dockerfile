FROM node:18

WORKDIR /app

# Copy the React artifact zip
COPY react-artifact-repo/frontend-artifact/*.zip ./artifact.zip

# Install unzip and serve
RUN apt-get update && apt-get install -y unzip && npm install -g serve

# Unzip and relocate the artifact directory
RUN unzip artifact.zip -d cart-project-clean && \
    CART_DIR=$(find cart-project-clean -mindepth 1 -maxdepth 1 -type d | head -n 1) && \
    echo "Detected project folder: $CART_DIR" && \
    mv "$CART_DIR" cart-project-clean-cleaned

# Set working directory to the extracted project
WORKDIR /app/cart-project-clean-cleaned

# Install dependencies
RUN npm install

# Fix potential permission issue with esbuild
RUN chmod -R +x node_modules/esbuild/bin || true

# Optional build
RUN npm run build || echo "Skipping build - maybe already done"

# Serve the built app
WORKDIR /app/cart-project-clean-cleaned/dist
EXPOSE 5173
CMD ["serve", "-s", ".", "-l", "5173"]
