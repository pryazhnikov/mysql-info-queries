-- Columns with fractional seconds in time values
select TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE, DATETIME_PRECISION
FROM information_schema.COLUMNS
WHERE data_type IN ('time', 'datetime', 'timestamp') AND DATETIME_PRECISION > 0;
