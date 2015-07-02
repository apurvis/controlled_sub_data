# Start up PostgreSQL
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

# push dev DB to production
heroku pg:reset DATABASE_URL
heroku pg:push controlled_sub_data_development DATABASE_URL --app controlled-sub-data

# Connect to psql
heroku pg:psql
