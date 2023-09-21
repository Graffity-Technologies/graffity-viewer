FROM node:16 as builder

WORKDIR /frontend

COPY package.json yarn.lock ./
RUN yarn
COPY . ./
RUN yarn test
RUN yarn build

FROM nginx:1.23.0-alpine
COPY --from=builder /frontend/build /usr/share/nginx/html
COPY --from=builder /frontend/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]