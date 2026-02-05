create view [dbo].[v_BV_matchstats]
as
SELECT 	BV.ValScheduleId,	BV.MatchStart,	BV.MatchEnd
,T.col.value('@sequence', 'int') AS Matchsequence
,T.col.value('@StatsMessage', 'varchar(1000)') AS MatchStatsMessage
,T.col.value('@EffectedRows', 'bigint') AS EffectedRows
,T.col.value('@ElapsedSeconds', 'int') AS MatchElapsedSeconds
from tvalbulkexecstats BV
cross apply BV.matchstats.nodes('/BulkValuationStats') AS T(col)
GO


