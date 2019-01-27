echo "-- creating data"
py -m data_builder
echo "-- creating tables"
mysql --user=root --database="ercolel-PR" --local-infile=1 --show-warnings --execute="source create.sql"
echo "-- loading data"
mysql --user=root --database="ercolel-PR" --local-infile=1 --show-warnings --execute="source load_data.sql"
echo "-- creating queries"
mysql --user=root --database="ercolel-PR" --local-infile=1 --show-warnings --execute="source queries.sql"
echo "-- creating operations"
mysql --user=root --database="ercolel-PR" --local-infile=1 --show-warnings --execute="source operations.sql"

# Write-Host -NoNewline "Press any key to close ..."
# $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp")
