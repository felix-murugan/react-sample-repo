FROM node:18
WORKDIR /app

RUN apt-get update && apt-get install -y p7zip-full curl && rm -rf /var/lib/apt/lists/*

# Download artifact zip from GitHub
RUN curl -L -o frontend-artifact-latest.zip https://github.com/felix-murugan/artifact-repo/raw/main/frontend-artifact/frontend-artifact-latest.zip

RUN 7z x frontend-artifact-latest.zip && rm frontend-artifact-latest.zip
WORKDIR /app/cart-project

RUN npm install
EXPOSE 5173
CMD ["npm", "run", "dev"]
