FROM node:16.17.0-apline as builder

WORKDIR /app

COPY ./package.json .

COPY ./yarn.lock .

RUN yarn insatll 

COPY . .

RUN yarn build

FROM nginx:satble-alpine as runner

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=builder /app/dist .

EXPOSE 80

ENTRYPOINT [ "nginx" , "-g" , "daemon off;" ]