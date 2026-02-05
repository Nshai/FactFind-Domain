create view v_fileimporthistory
as
select FileImportType,sum(datediff(ss,EntryDate,A.LastupdatedDate)) as TotalTime,avg(convert(bigint,datediff(ms,EntryDate,A.LastupdatedDate)))/count(1) as AvgTime_per_item_ms,count(Distinct A.FileImportHeaderId) as FileCount,count(1) ItemCount
from TFileImportHeader A
join TFileImportItem B on A.FileImportHeaderId = B.FileImportHeaderId
where convert(date,EntryDate) = convert(date,getdate())
group by FileImportType
