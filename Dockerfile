# Use the official Node.js image as the base image for building the application
FROM node:18 AS build

# Set the working directory in the containers
WORKDIR /usr/src/app

# Copy only package.json and package-lock.json to leverage Docker cache
COPY package*.json ./

# Install only production dependencies
RUN npm install --production

# Copy the rest of the application source code
COPY . .

# Build the applications
RUN npm run build

# Use a lightweight web server to serve the built applications
FROM nginx:alpine

# Remove default Nginx contents
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output from the build stage to the Nginx html directory
COPY --from=build /usr/src/app/build /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]
