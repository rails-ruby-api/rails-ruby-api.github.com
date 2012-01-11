#!/bin/bash
# Generates merged sdoc

RAILS_VERSION="v3.1.3"
RUBY_VERSION="1.9.3-p0"

gem install bundler sdoc
mkdir repos
mkdir sdocs
cd repos

# Rails
git clone https://github.com/rails/rails.git
cd rails
git ch $RAILS_VERSION
sdoc -o ../sdocs/rails-$RAILS_VERSION -f sdoc -n -N .

# Ruby
cd ..
mkdir ruby
cd ruby
curl -o ruby.tar.bz2 http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-$RUBY_VERSION.tar.bz2
tar xjf ruby.tar.bz2
cd ruby-$RUBY_VERSION
sdoc -o ../../sdocs/ruby-$RUBY_VERSION -f sdoc -n -N .

# Merge sdocs
cd ../../sdocs

sdoc-merge --title "Ruby $RUBY_VERSION, Rails $RAILS_VERSION" --op rails-ruby --names "Ruby $RUBY_VERSION,Rails $RAILS_VERSION" ruby-$RUBY_VERSION rails-$RAILS_VERSION

# cleanup
rm -rf rails-$RAILS_VERSION ruby-$RUBY_VERSION
rm -rf ../repos

echo "========================="
echo "Merged SDOC in rails-ruby"
echo "========================="
