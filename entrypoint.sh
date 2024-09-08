#!/bin/bash
set -e

# Function to wait for MySQL
echo "Waiting for MySQL to be ready..."
until mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW DATABASES;" > /dev/null 2>&1; do
  sleep 5
done
echo "MySQL is ready!"

# Run database migrations
echo "Running migrations..."
bundle exec rake db:migrate

# Wait for Elasticsearch to be ready
echo "Waiting for Elasticsearch to be ready..."
until curl -s "$ELASTICSEARCH_HOST:9200" > /dev/null; do
  sleep 5
done
echo "Elasticsearch is ready!"

# Index Elasticsearch data
echo "Indexing Elasticsearch data..."
bundle exec rake searchkick:reindex  # or any other rake task to index your data

# Start Sidekiq (for background jobs)
echo "Starting Sidekiq..."
bundle exec sidekiq &

# If you're using Celery (Python task queue), start Celery workers here
# echo "Starting Celery..."
# celery -A your_project worker --loglevel=info &

# Start Rails server
echo "Starting Rails server..."
exec "$@"
