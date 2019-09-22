pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

bundle install
bundle exec rake db:drop RAILS_ENV=development
heroku pg:pull HEROKU_POSTGRESQL_NAVY_URL controlled_sub_data_development --app controlled-sub-data
bundle exec rails server
