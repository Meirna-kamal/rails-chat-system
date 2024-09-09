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

# Install MySQL client
RUN apt-get update && apt-get install -y default-mysql-client

# Copy the app
COPY . .

# Copy the entrypoint script into the image
COPY entrypoint.sh /usr/bin/

# Ensure the entrypoint script is executable
RUN chmod +x /usr/bin/entrypoint.sh

# Expose the port
EXPOSE 3000

# Set the entrypoint script
ENTRYPOINT ["/usr/bin/entrypoint.sh"]

# Default command to start the Rails server (overridable in docker-compose.yml)
CMD ["rails", "server", "-b", "0.0.0.0"]
