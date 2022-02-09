
FROM jekyll/jekyll:3.8.3 as build-stage

ARG PORT

WORKDIR /tmp

COPY Gemfile* ./

RUN bundle install

RUN echo $PORT

WORKDIR /usr/src/app

COPY . .

RUN chown -R jekyll .

RUN jekyll build

FROM nginx:alpine

COPY ./public/ /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'