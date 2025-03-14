# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./ 
RUN npm ci
COPY . . 
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html 
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


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
