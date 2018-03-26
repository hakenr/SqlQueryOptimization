-- Hlavní statistika execution plans
SELECT TOP 10 * FROM sys.dm_exec_query_stats
-- + funkce sys.dm_exec_sql_text
-- + funkce sys.dm_exec_query_plan

-- Most expensive queries
SELECT TOP 20
    SUBSTRING(qt.TEXT, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(qt.TEXT)
            ELSE qs.statement_end_offset
            END - qs.statement_start_offset)/2)+1)
        AS query_text,
    db.name AS [db_name],
    qs.total_elapsed_time/1000 AS total_elapsed_time_ms,
    qs.total_elapsed_time/qs.execution_count/1000 AS average_elapsed_time_ms,
    qs.last_elapsed_time/1000 AS last_elapsed_time_ms,
    qs.execution_count,
    qs.total_worker_time/1000 AS total_worker_time_ms,
    qs.total_worker_time/qs.execution_count/1000 AS average_worker_time_ms,
    qs.last_worker_time/1000 AS last_worker_time_ms,
    qs.last_execution_time,
    qs.total_logical_reads,
    qs.last_logical_reads,
    qs.total_logical_writes,
    qs.last_logical_writes
    --qp.query_plan
    FROM sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
        CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
        LEFT JOIN sys.databases db ON (qt.dbid = db.database_id)
    -- WHERE db.name='DatabaseName'
    -- ORDER BY qs.total_logical_reads DESC
    -- ORDER BY qs.total_logical_writes DESC
    -- ORDER BY qs.last_worker_time DESC -- CPU time (active)
    -- ORDER BY qs.last_elapsed_time DESC -- clock time (vèetnì èekání na locky, atp.)
    -- ORDER BY qs.total_worker_time DESC
    ORDER BY qs.total_elapsed_time DESC



-- Chybìjící indexy
SELECT TOP 10 * FROM sys.dm_db_missing_index_details
-- + funkce sys.dm_db_missing_index_columns 
-- + view sys.dm_db_missing_index_group_stats

SELECT
	mid.statement
	  ,migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) AS improvement_measure,OBJECT_NAME(mid.Object_id),
	  'CREATE INDEX [missing_index_' + CONVERT (VARCHAR, mig.index_group_handle) + '_' + CONVERT (VARCHAR, mid.index_handle)
	  + '_' + LEFT (PARSENAME(mid.statement, 1), 32) + ']'
	  + ' ON ' + mid.statement
	  + ' (' + ISNULL (mid.equality_columns,'')
		+ CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END
		+ ISNULL (mid.inequality_columns, '')
	  + ')'
	  + ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS create_index_statement,
	  migs.*, mid.database_id, mid.[object_id]
	FROM sys.dm_db_missing_index_groups mig
		INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
		INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
	WHERE migs.avg_total_user_cost * (migs.avg_user_impact / 100.0) * (migs.user_seeks + migs.user_scans) > 10
	ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC

