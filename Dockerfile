FROM ruby:3.3

WORKDIR /app

COPY ./Gemfile ./Gemfile.lock ./

ENV LANG=ja_JP.UTF-8 \
    GEM_HOME=/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
    BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

RUN bundle config path 'vendor/bundle' && \
    bundle install
