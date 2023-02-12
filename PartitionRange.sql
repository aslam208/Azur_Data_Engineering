SELECT 
t.name AS TableName, 
i.name AS IndexName, 
p.partition_number,
p.partition_id,
f.type_desc,
c.name AS PartitioningColumnName,
CONVERT(nvarchar(255), r.value) as boundary
FROM sys.tables AS t
JOIN sys.indexes AS i
    ON t.object_id = i.object_id
JOIN sys.partitions AS p
    ON i.object_id = p.object_id AND i.index_id = p.index_id
JOIN  sys.partition_schemes AS s
    ON i.data_space_id = s.data_space_id
JOIN sys.partition_functions AS f
    ON s.function_id = f.function_id
LEFT JOIN sys.partition_range_values AS r
    ON f.function_id = r.function_id and r.boundary_id = p.partition_number
JOIN sys.index_columns AS ic
    ON ic.object_id = i.object_id
    AND ic.index_id = i.index_id AND ic.partition_ordinal > 0
JOIN sys.columns AS c
    ON t.object_id = c.object_id
WHERE t.name = @table
    AND c.column_id = ic.column_id
ORDER BY p.partition_number;