#!/bin/bash
echo "-- creating data"
python3 -m data_builder

alias custom_mysql='mysql -h localhost -P3306 --user="ercolel" --password=$( cat $HOME/bd1819.password ) -D ercolel-PR --default-character-set=utf8 --show-warnings'

echo "-- creating tables"
custom_mysql < create.sql
echo "-- loading data"
custom_mysql < load_data.sql
echo "-- creating queries, triggers and functions"
custom_mysql < queries.sql
custom_mysql < operations.sql
