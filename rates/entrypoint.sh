#!/bin/sh
PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USER < rates.sql
gunicorn -b :3000 wsgi