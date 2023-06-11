gem install bundler
which bundle
bundle init
echo 'gem "cocoapods"' >> ./Gemfile
bundle config --local path vendor/bundle
bundle install
bundle exec pod init
