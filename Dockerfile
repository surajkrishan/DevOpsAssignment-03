# Stage 0, "build-stage"
FROM node:alpine as build-stage

WORKDIR /app

COPY package*.json /app/

RUN npm install

COPY ./ /app/

RUN npm run build

# Stage 1, based on Nginx
FROM nginx:stable-alpine

COPY --from=build-stage /app/build/ /usr/share/nginx/html

COPY --from=build-stage /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 3000 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]