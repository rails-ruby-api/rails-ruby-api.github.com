#!/bin/bash
# Generates merged sdoc

RAILS_VERSION="v4.2.6"
RUBY_VERSION="2.3.0"

gem install sdoc

echo "Creating directories"
mkdir -p repos
mkdir -p sdocs
cd repos

# Rails
echo "Fetching Rails $RAILS_VERSION repo from github.com"
rm -rf rails
git clone https://github.com/rails/rails.git
cd rails
git ch $RAILS_VERSION

echo "Generating SDOC"
sdoc -o ../../sdocs/rails-$RAILS_VERSION --line-numbers --format=sdoc -T rails --github .

# Ruby
echo "Fetching ruby $RUBY_VERSION from ruby-lang.org"
cd ..
mkdir ruby
cd ruby
curl -o ruby.tar.bz2 http://ftp.ruby-lang.org/pub/ruby/ruby-$RUBY_VERSION.tar.bz2
tar xjf ruby.tar.bz2
cd ruby-$RUBY_VERSION
echo "Generating SDOC"
sdoc -o ../../../sdocs/ruby-$RUBY_VERSION --line-numbers --format=sdoc -T rails --github .

# Merge sdocs
cd ../../../sdocs

echo "Merging Ruby and Rails SDOC"
sdoc-merge --title "Ruby $RUBY_VERSION, Rails $RAILS_VERSION" --op rails-ruby --names "Ruby $RUBY_VERSION,Rails $RAILS_VERSION" ruby-$RUBY_VERSION rails-$RAILS_VERSION

# cleanup
echo "Cleaning up"
rm -rf rails-$RAILS_VERSION ruby-$RUBY_VERSION
rm -rf ../repos

echo "================================"
echo "Merged SDOC is now in rails-ruby"
echo "================================"
