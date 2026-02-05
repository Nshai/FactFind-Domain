create view v_BV_processtats
as
SELECT 	BV.ValScheduleId,	BV.ProcessingStart,	BV.ProcessingEnd
,T1.col.value('@sequence', 'int') AS Processsequence
,T1.col.value('@StatsMessage', 'varchar(1000)') AS ProcessStatsMessage
,T1.col.value('@effectedrows', 'bigint') AS EffectedRows
,T1.col.value('@elapsedseconds', 'int') AS ProcessElapsedSeconds
from tvalbulkexecstats BV
cross apply BV.Processstats.nodes('/BulkValuationStats') AS T1(col)
go