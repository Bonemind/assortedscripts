FROM ruby:2.4.0-slim

RUN apt-get update && apt-get install -y \
	build-essential

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . ./

CMD ["bundle", "exec", "ruby", "main.rb"]
