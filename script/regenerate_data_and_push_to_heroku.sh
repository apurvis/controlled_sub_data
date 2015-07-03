bundle exec rails runner script/regenerate_tables_from_schedule_csvs.rb

heroku pg:reset DATABASE_URL --confirm controlled-sub-data
heroku pg:push controlled_sub_data_development DATABASE_URL --app controlled-sub-data

bundle exec rails runner script/add_alternate_names.rb