FROM ruby:2.6.7 
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Ensure we install an up-to-date version of Node
# See https://github.com/yarnpkg/yarn/issues/2888
ADD https://dl.yarnpkg.com/debian/pubkey.gpg /tmp/yarn-pubkey.gpg
RUN apt-key add /tmp/yarn-pubkey.gpg && rm /tmp/yarn-pubkey.gpg
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list


RUN apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential nodejs libpq-dev yarn
RUN mkdir /app
WORKDIR /app 
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install
ADD . /appdcu
