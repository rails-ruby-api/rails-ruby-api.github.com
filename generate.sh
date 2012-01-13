#!/bin/bash
# Generates merged sdoc

RAILS_VERSION="v3.1.3"
RUBY_VERSION="1.9.3-p0"

echo "Creating directories"
gem install sdoc
echo "************************************************************************************************************************************"
echo "Until the author of sdoc merges pull request #32"
echo "copy https://raw.github.com/vijaydev/sdoc/45d1393efc1b41cb0b4aa3506570b9e7bfaea674/lib/sdoc/github.rb to your doc lib/github.rb file"
echo "************************************************************************************************************************************"
pause
mkdir repos
mkdir sdocs
cd repos

# Rails
echo "Fetching Rails $RAILS_VERSION repo from github.com"
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
curl -o ruby.tar.bz2 http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-$RUBY_VERSION.tar.bz2
tar xjf ruby.tar.bz2
cd ruby-$RUBY_VERSION
echo "Generating SDOC"
sdoc -o ../../sdocs/ruby-$RUBY_VERSION --line-numbers --format=sdoc -T rails --github .

# Merge sdocs
cd ../../sdocs

echo "Merging Ruby and Rails SDOC"
sdoc-merge --title "Ruby $RUBY_VERSION, Rails $RAILS_VERSION" --op rails-ruby --names "Ruby $RUBY_VERSION,Rails $RAILS_VERSION" ruby-$RUBY_VERSION rails-$RAILS_VERSION

# cleanup
echo "Cleaning up"
rm -rf rails-$RAILS_VERSION ruby-$RUBY_VERSION
rm -rf ../repos

echo "==================================="
echo "Merged SDOC is now in in rails-ruby"
echo "==================================="
