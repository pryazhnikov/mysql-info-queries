-- Schema sizes info
SELECT s.SCHEMA_NAME, COUNT(*) AS TOTAL_TABLES, SUM(TABLE_ROWS) AS TOTAL_ROWS,
    CONCAT(ROUND(SUM(DATA_LENGTH) / (1024 * 1024), 2), 'M') AS TOTAL_DATA_LENGTH,
    CONCAT(ROUND(SUM(INDEX_LENGTH) / (1024 * 1024), 2), 'M') AS TOTAL_INDEX_LENGTH,
    CONCAT(ROUND((SUM(DATA_LENGTH) + SUM(INDEX_LENGTH)) / (1024 * 1024), 2), 'M') AS TOTAL_SIZE
FROM information_schema.SCHEMATA s
LEFT JOIN information_schema.TABLES AS t ON s.SCHEMA_NAME=t.TABLE_SCHEMA AND t.TABLE_TYPE='BASE TABLE'
WHERE s.SCHEMA_NAME NOT IN ('mysql', 'information_schema')
GROUP BY s.SCHEMA_NAME
ORDER BY TOTAL_SIZE DESC;