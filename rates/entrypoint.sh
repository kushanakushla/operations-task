#!/bin/sh
psql -U $POSTGRES_USER -h $POSTGRES_HOST -d $POSTGRES_DB -f rates.sql 
gunicorn -b :3000 wsgi