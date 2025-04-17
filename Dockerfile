# FROM node:20-alpine AS build
# RUN apk update && apk upgrade   # Upgrade all Alpine packages
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci
# COPY . .
# RUN npm run build

# FROM nginx:alpine
# RUN apk update && apk upgrade   # Ensure the latest security fixes
# COPY --from=build /app/dist /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

FROM node:20-alpine AS base
WORKDIR /app
# First copy package files, install deps, then the rest of the source code.
COPY package*.json ./  
#package* includes package.json and package-lock.json
RUN npm ci
# install dependencies, caches this layer, will not install deps evrytime its run, decreases build time.
COPY . .
RUN npm run build # build the app

FROM nginx:alpine
COPY --from=base /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
# Dockerfile for a Node.js application with Nginx as a reverse proxy

# # Build stage
# FROM node:20-alpine AS build
# WORKDIR /app
# COPY package*.json ./
# #The * (wildcard) matches both package.json and package-lock.json.
# RUN npm ci
# COPY . .
# RUN npm run build

# # Production stage
# FROM nginx:alpine
# COPY --from=build /app/dist /usr/share/nginx/html
# # nginx reads static content from this location, so src code files to be present here
# # Add nginx configuration if needed
# # COPY nginx.conf /etc/nginx/conf.d/default.conf
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]
