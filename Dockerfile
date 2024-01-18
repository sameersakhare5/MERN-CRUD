# Stage 1: Build the React Frontend
FROM node:14 as frontend-builder

WORKDIR /app/client

COPY client/package*.json ./

RUN npm install

COPY client/ .

RUN npm run build


# Stage 2: Build the Node.js/Express Backend
FROM node:14 as backend-builder

WORKDIR /app/server

COPY server/package*.json ./

RUN npm install

COPY server/ .

# Stage 3: Create the Final Image with Nginx
FROM nginx:alpine

# Copy built React app from the frontend-builder stage
COPY --from=frontend-builder /app/client/build /usr/share/nginx/html

# Copy backend files from the backend-builder stage
COPY --from=backend-builder /app/server /usr/share/nginx/html/api

# Expose port 80 for Nginx
EXPOSE 80

# Default command to start Nginx
CMD ["nginx", "-g", "daemon off;"]
