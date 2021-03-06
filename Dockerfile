FROM ruby:2.3

# Install apt based dependencies required to run Rails as 
# well as RubyGems. As the Ruby image itself is based on a 
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \ 
  build-essential \ 
  nodejs \
  openjdk-7-jre \
  openjdk-7-jdk

# Configure the main working directory. This is the base 
# directory used in any further RUN, COPY, and ENTRYPOINT 
# commands.
RUN mkdir -p /recurring
WORKDIR /recurring

# Copy the Gemfile as well as the Gemfile.lock and install 
# the RubyGems. This is a separate step so the dependencies 
# will be cached unless changes to one of those two files 
# are made.
COPY Gemfile Gemfile.lock ./ 
RUN gem install bundler
RUN gem install json -v '1.8.3'
RUN gem install rdoc -v '4.2.0'
RUN bundle install --retry 5 --full-index

# Copy the main application.
COPY . ./
RUN rake assets:precompile RAILS_ENV=production

# The main command to run when the container starts. Also 
# tell the Rails dev server to bind to all interfaces by 
# default.
CMD RAILS_ENV=staging bundle exec rails server -b 0.0.0.0 -p $PORT