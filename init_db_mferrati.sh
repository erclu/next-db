#!/bin/bash
echo "-- creating data"
python3 -m data_builder
echo "-- creating tables"
mysql -h localhost -P3306 -u mferrati -D mferrati-PR --local-infile=1 --password=$( cat $HOME/bd1819.password ) --show-warnings < create.sql
echo "-- loading data"
mysql -h localhost -P3306 -u mferrati -D mferrati-PR --local-infile=1 --password=$( cat $HOME/bd1819.password ) --show-warnings < load_data.sql