FROM node:16 as builder

ARG REACT_APP_FIREBASE_APIKEY
ARG REACT_APP_FIREBASE_AUTHDOMAIN
ARG REACT_APP_FIREBASE_PROJECTID
ARG REACT_APP_FIREBASE_STORAGEBUCKET
ARG REACT_APP_FIREBASE_MESSAGINGSENDERID
ARG REACT_APP_FIREBASE_APPID
ARG REACT_APP_MAPBOX_ACCESS_TOKEN
ARG REACT_APP_STAGE
ARG REACT_APP_API_KEY

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