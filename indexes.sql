-- identical indexes
SELECT TABLE_SCHEMA, TABLE_NAME, GROUP_CONCAT(INDEX_NAME) AS DUPLICATE_INDEXES, INDEX_COLUMNS
FROM (
	SELECT TABLE_SCHEMA, TABLE_NAME, INDEX_NAME, INDEX_TYPE, GROUP_CONCAT(COLUMN_NAME) AS INDEX_COLUMNS
	FROM information_schema.STATISTICS
	WHERE TABLE_SCHEMA = DATABASE()
	GROUP BY TABLE_SCHEMA, TABLE_NAME, INDEX_NAME
) AS t
GROUP BY TABLE_SCHEMA, TABLE_NAME, INDEX_COLUMNS
HAVING COUNT(*) > 1;

-- same prefix indexes
SELECT t1.TABLE_NAME, t1.INDEX_NAME, t2.INDEX_NAME, t1.INDEX_COLUMNS, t2.INDEX_COLUMNS
FROM (
	SELECT TABLE_NAME, INDEX_NAME, COUNT(*) AS NUM_COLUMNS, GROUP_CONCAT(COLUMN_NAME) AS INDEX_COLUMNS
	FROM information_schema.STATISTICS
	WHERE TABLE_SCHEMA = DATABASE()
	GROUP BY TABLE_NAME, INDEX_NAME
) AS t1, (
	SELECT TABLE_NAME, INDEX_NAME, COUNT(*) AS NUM_COLUMNS, GROUP_CONCAT(COLUMN_NAME) AS INDEX_COLUMNS
	FROM information_schema.STATISTICS
	WHERE TABLE_SCHEMA = DATABASE()
	AND INDEX_TYPE = 'BTREE' -- btree indexes only have left prefix semantics
	GROUP BY TABLE_NAME, INDEX_NAME
	HAVING COUNT(*) > 1 -- At least 2 column is mandatory to have a prefix
) t2
WHERE t1.TABLE_NAME=t2.TABLE_NAME
AND t2.NUM_COLUMNS > t1.NUM_COLUMNS
AND t2.INDEX_COLUMNS LIKE CONCAT(t1.INDEX_COLUMNS, ',%');
