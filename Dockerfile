FROM alpine
MAINTAINER Kohei MATSUSHITA <ma2shita+git@ma2shita.jp>

ENV APP_ROOT /frightboard

# libstdc++ for EventMachine
# ruby-irb, ruby-bigdecimal for Rack
RUN apk --update --no-cache add bash git ruby supervisor ruby-irb ruby-bigdecimal libstdc++ \
 && apk --update --no-cache add --virtual=.dep ruby-dev make g++ musl-dev libffi-dev linux-headers tzdata sqlite-dev \

 && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \

 && gem install bundler json io-console --no-rdoc --no-ri \

 && mkdir ${APP_ROOT} \
 && git clone --depth 1 https://github.com/ma2shita/frightboard.git \
 && (cd $APP_ROOT ; bundle install --path vendor/bundle --jobs 4 ; rm -rf vendor/bundle/ruby/2.2.0/cache/* ; find vendor/bundle -type d -a -name spec | xargs rm -rf) \
 && rm -rf ${APP_HOME}/.bundle/cache/* \

 && apk del .dep

RUN mkdir -p /etc/supervisor.d /var/log/supervisord /var/run/supervisord
COPY supervisor-app.ini /etc/supervisor.d/app.ini
COPY supervisord.conf /etc/supervisord.conf

COPY *-docker-entrypoint.sh /
RUN chmod 755 /*-docker-entrypoint.sh

COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

WORKDIR $APP_ROOT
EXPOSE 9292
CMD ["/entrypoint.sh"]
