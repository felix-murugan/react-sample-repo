# Use Node base image
FROM node:18

# Set working directory
WORKDIR /app

# Install p7zip to extract .zip files
RUN apt-get update && \
    apt-get install -y p7zip-full

# # Copy and extract zip file
COPY react-artifact-repo/frontend-artifact/frontend-artifact-latest.zip ./

RUN 7z x frontend-artifact-latest.zip && rm frontend-artifact-latest.zip


# 👇 Add this debug line to list the extracted files/folders
RUN echo "=== Extracted contents ===" && ls -la





# WORKDIR /app/frontend-artifact-latest/cart-project

# COPY frontend-artifact-latest/cart-project/package*.json ./
# RUN npm install
# Move into your React project directory
# WORKDIR /app/frontend-artifact-latest/cart-project

# Install dependencies
# RUN npm cache clean --force
# RUN npm install --legacy-peer-deps

# Build React app (Vite uses `vite build` behind the scenes with npm run build)
# RUN npm run build

# Stage 2: Serve with NGINX
# FROM nginx:alpine

# # Copy build output from builder stage
# COPY --from=builder /app/frontend-artifact-latest/cart-project/dist /usr/share/nginx/html
# COPY ./nginx.conf /etc/nginx/conf.d/default.conf
# # Expose port 80
EXPOSE 80

# Start NGINX server
CMD ["npm", "run", "dev"]
