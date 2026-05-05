FROM ruby:3.2.3-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev \
    pkg-config \
  && rm -rf /var/lib/apt/lists/*

ENV BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT=development:test \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
RUN chmod +x bin/k8s-entrypoint

EXPOSE 3000

ENTRYPOINT ["bin/k8s-entrypoint"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
