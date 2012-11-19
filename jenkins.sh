set -e

export HUDSON=true

source ~/.rvm/scripts/rvm
rvm try_install ruby-1.9.2

rvm use --create ruby-1.9.2@gem_version_check
gem install bundler

bundle install
bundle exec rake

