# Base image
FROM node:20-alpine

# Create app directory
WORKDIR /usr/src/app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY ../../signaling-server/package*.json ./
COPY ../../signaling-server/tsconfig.* ./

# Install app dependencies
RUN npm install

# Bundle app source
COPY . .

# Copy the .env and .env.development files
COPY ../signaling-server/.env ./

# Creates a "dist" folder with the production build
# RUN npm run build

# Expose the port on which the app will run
EXPOSE 8080

# Start the server using the production build
CMD ["npm", "run", "start:dev"]