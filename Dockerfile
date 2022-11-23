FROM ruby:2.7.2-alpine

# Dockerfile内で使用する環境変数の指定
ARG WORKDIR
ARG RUNTIME_PACKAGES="nodejs tzdata postgresql-dev postgresql git"
ARG DEV_PACKAGES="build-base curl-dev"

# Dockerfile、コンテナ内で使用する環境変数の指定
ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR ${HOME}

COPY Gemfile* ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle config set force_ruby_platform true && \
    bundle install -j4 && \
    apk del build-dependencies

COPY . ./

CMD ["rails", "server", "-b", "0.0.0.0"]