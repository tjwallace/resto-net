# Resto-Net.ca

[Resto-Net.ca](http://resto-net.ca/) is an open database of Montreal's health inspections.

# Dependencies

## RVM

It is recommended to use Resto-Net with RVM. Instructions for installing RVM on OS X Lion are given below as there are a few gotchas. Follow RVM's [installation instructions](http://beginrescueend.com/rvm/install/) for other systems.

### OS X Lion

The following script assume you are using the Bash UNIX shell.

    bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
    echo 'export CC=gcc-4.2' >> .bash_profile
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"' >> .bash_profile
    source .bash_profile
    rvm install 1.8.7
    rvm system ; rvm gemset export system.gems ; rvm 1.8.7 ; rvm gemset import system
    rvm install 1.9.2
    rvm use 1.9.2 --default

## PostgreSQL

Resto-Net requires PostgreSQL for its full-text search.

### OS X Lion

    brew install postgresql
    initdb /usr/local/var/postgres
    mkdir -p ~/Library/LaunchAgents
    cp /usr/local/Cellar/postgresql/9.0.4/org.postgresql.postgres.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/org.postgresql.postgres.plist
    env ARCHFLAGS="-arch x86_64" gem install pg

### Ubuntu 10.04

    sudo apt-get install postgresql libpq-dev
    sudo gem install pg
    sudo -u postgres psql -c "ALTER USER postgres WITH ENCRYPTED PASSWORD 'your_password';" template1

# Installation

    git clone git@github.com:tjwallace/resto-net.git
    cd resto-net
    bundle install
    cp config/database.example.yml config/database.yml
    # edit config/database.yml in your favorite editor
    bundle exec rake db:setup
    bundle exec rake data:import
    rails server thin

# Running tests

    bundle exec rake db:test:prepare
    bundle exec rake spec

# Updating data

    bundle exec rake data:update

From time to time, the data source changes historical data. Run the following commands to refresh historical data:

    rm -f data/*.xml
    bundle exec rake data:download
    bundle exec rake data:import

# Deployment

## Heroku

[Create a Heroku account](http://heroku.com/signup) and setup SSH keys as described on [Getting Started with Heroku](http://devcenter.heroku.com/articles/quickstart).

    gem install heroku
    heroku create
    git push heroku master
    heroku rake db:migrate
    heroku rake data:import
    heroku addons:add cron:daily
    heroku addons:add logging:expanded
