#!/bin/bash
set -e

# Function to wait for MySQL
until mysql -h"db" -u"rails_user" -p"MysqlPass321" -e "SHOW DATABASES;"; do
  echo "Waiting for MySQL to be ready..."
  sleep 5
done
echo "MySQL is ready!"

# Run database migrations
echo "Running migrations..."
bundle exec rake db:migrate

# Wait for Elasticsearch to be ready
echo "Waiting for Elasticsearch to be ready..."
until curl -s "http://elasticsearch:9200" > /dev/null; do
  sleep 5
done
echo "Elasticsearch is ready!"

# Index Elasticsearch data
echo "Indexing Elasticsearch data..."
bundle exec rails runner "Message.__elasticsearch__.create_index!(force: true)"
bundle exec rails runner "Message.__elasticsearch__.import(force: true)"

# Start Sidekiq (for background jobs)
echo "Starting Sidekiq..."
bundle exec sidekiq &

# Start Rails server
echo "Starting Rails server..."
exec "$@"
