#!/bin/bash
set -e

cd /app/decide

# Run migrations
python manage.py migrate --noinput

# Collect static files
python manage.py collectstatic --noinput

# Create superuser if it doesn't exist
python manage.py shell -c "from django.contrib.auth.models import User; User.objects.filter(username='admin') or User.objects.create_superuser('admin', 'admin@example.com', 'admin')"

# Start Gunicorn
exec gunicorn -w 4 decide.wsgi --timeout=500 -b 0.0.0.0:$PORT
