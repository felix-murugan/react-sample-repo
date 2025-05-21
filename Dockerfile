FROM node:18

WORKDIR /app

RUN apt-get update && \
    apt-get install -y p7zip-full && \
    rm -rf /var/lib/apt/lists/*

# Copy the zip from build context (downloaded in CI)
COPY frontend-artifact-latest.zip ./

# Extract it
RUN 7z x frontend-artifact-latest.zip && rm frontend-artifact-latest.zip

# Set working dir to extracted folder
WORKDIR /app/cart-project

# Install dependencies and run app
RUN npm install

EXPOSE 5173
CMD ["npm", "run", "dev"]
