FROM sairambadari/strapi:latest

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy the Strapi app
COPY . .

# Build Strapi admin panel
RUN npm run build

# Expose port
EXPOSE 1337

# Start the app
CMD ["npm", "start"]

