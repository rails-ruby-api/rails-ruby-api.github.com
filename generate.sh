#!/bin/bash
# Generates merged sdoc

# Colors
ccred=$(log -e "\033[31m")
ccgreen=$(log -e "\033[32m")
ccyellow=$(log -e "\033[33m")
ccend=$(log -e "\033[0m")

RAILS_VERSION="v5.0.2"
RUBY_VERSION="2.3.1"

gem install --force sdoc

log() {
  log "${ccgreen}${1}${ccend}"
}

log "Creating directories"
mkdir -p repos
mkdir -p sdocs
cd repos

# Rails
log "Fetching Rails $RAILS_VERSION repo from github.com"
rm -rf rails
git clone --branch ${RAILS_VERSION} --single-branch --depth 1 https://github.com/rails/rails.git
cd rails
git ch $RAILS_VERSION

log "Generating SDOC for Rails ${RAILS_VERSION} in the background"
sdoc -o ../../sdocs/rails-$RAILS_VERSION --line-numbers --format=sdoc -T rails --github . &
RAILS_PID=$!

# Ruby
log "Fetching ruby $RUBY_VERSION from ruby-lang.org"
cd ..
rm -rf ruby
mkdir ruby
cd ruby
curl -o ruby.tar.bz2 http://ftp.ruby-lang.org/pub/ruby/ruby-$RUBY_VERSION.tar.bz2
tar xjf ruby.tar.bz2
cd ruby-$RUBY_VERSION
log "Generating SDOC for ruby ${RUBY_VERSION} in the background"
sdoc -o ../../../sdocs/ruby-$RUBY_VERSION --line-numbers --format=sdoc -T rails --github . &
RUBY_PID=$!

log "Waiting for RUBY and RAILS sdoc background jobs to finish"
wait $RAILS_PID $RUBY_PID

# Merge sdocs
cd ../../../sdocs

log "Merging Ruby and Rails SDOC"
sdoc-merge --title "Ruby $RUBY_VERSION, Rails $RAILS_VERSION" --op rails-ruby --names "Ruby $RUBY_VERSION,Rails $RAILS_VERSION" ruby-$RUBY_VERSION rails-$RAILS_VERSION

# cleanup
log "Cleaning up"
rm -rf rails-$RAILS_VERSION ruby-$RUBY_VERSION
rm -rf ../repos

log "========================================"
log "Merged SDOC is now in 'sdocs/rails-ruby'"
log "========================================"
