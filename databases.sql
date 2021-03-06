-- Schema sizes info
SELECT s.SCHEMA_NAME, COUNT(t.TABLE_NAME) AS TOTAL_TABLES, SUM(TABLE_ROWS) AS TOTAL_ROWS,
    ROUND(SUM(DATA_LENGTH) / (1024 * 1024), 2) AS TOTAL_DATA_SIZE_MB,
    ROUND(SUM(INDEX_LENGTH) / (1024 * 1024), 2) AS TOTAL_INDEX_SIZE_MB,
    ROUND((SUM(DATA_LENGTH) + SUM(INDEX_LENGTH)) / (1024 * 1024), 2) AS TOTAL_SIZE_MB
FROM information_schema.SCHEMATA s
LEFT JOIN information_schema.TABLES AS t ON s.SCHEMA_NAME=t.TABLE_SCHEMA AND t.TABLE_TYPE='BASE TABLE'
WHERE s.SCHEMA_NAME NOT IN ('mysql', 'information_schema', 'performance_schema', 'sys')
GROUP BY s.SCHEMA_NAME
ORDER BY TOTAL_SIZE_MB DESC;
