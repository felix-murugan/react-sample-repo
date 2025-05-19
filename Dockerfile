FROM node:18

# Set working directory
WORKDIR /app

# Copy artifact zip into container
COPY react-artifact-repo/frontend-artifact/*.zip ./artifact.zip

# Install unzip and serve
RUN apt-get update && apt-get install -y unzip && npm install -g serve

# Unzip artifact and rename if needed
RUN unzip artifact.zip -d cart-project-clean && \
    CART_DIR=$(find cart-project-clean -mindepth 1 -maxdepth 1 -type d | head -n 1) && \
    echo "Detected project folder: $CART_DIR" && \
    mv "$CART_DIR" cart-project-clean-cleaned

# Change to the correct working directory (where package.json exists)
WORKDIR /app/cart-project-clean-cleaned

# Install dependencies
RUN npm install

# Optional: Build again if needed
RUN npm run build || echo "Skipping build - maybe already done"

# Serve the built app
WORKDIR /app/cart-project-clean-cleaned/dist
EXPOSE 5173
CMD ["serve", "-s", ".", "-l", "5173"]
