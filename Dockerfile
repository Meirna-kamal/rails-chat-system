# Base image with Ruby
FROM ruby:3.1

# Set the working directory
WORKDIR /usr/src/app

# Install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Install Node.js and Yarn for Rails asset pipeline
RUN curl -sS https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g yarn

# Install Elasticsearch plugin (optional, if required)
RUN curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz

# Copy the app
COPY . .

# Expose the port
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
