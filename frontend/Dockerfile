FROM node:20-alpine AS build

WORKDIR /usr/src/app

# Copy dependency files first (better caching)
COPY package.json package-lock.json ./

# Install dependencies using cache mount
RUN --mount=type=cache,target=/usr/src/app/.npm \
npm set cache /usr/src/app/.npm && \
npm install

# Copy the rest of the source code
COPY . .

RUN npm run build

# Serve usign nginx
FROM nginx:1.29.5-alpine

RUN rm /etc/nginx/conf.d/default.conf

# Use COPY --link to avoid breaking cache if we change the second stage base image
COPY --link default.conf.template /etc/nginx/templates/default.conf.template

# Copy the built files from the build stage
COPY --from=build /usr/src/app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
