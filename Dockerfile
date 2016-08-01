FROM ruby:2.3.1
WORKDIR /app
ENTRYPOINT ["/app/docker/entrypoint.sh"]
COPY ./lib/gem_version_check/version.rb /app/lib/gem_version_check/version.rb
COPY Gemfile* gem_version_check.gemspec /app/
RUN BUNDLE_SILENCE_ROOT_WARNING=1 bundle install -j4 --without development test
ADD ./ /app
