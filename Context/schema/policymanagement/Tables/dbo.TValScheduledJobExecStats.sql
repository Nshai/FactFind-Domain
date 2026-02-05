create table TValScheduledJobExecStats (
	ValScheduledJobExecStatsID int NOT NULL  identity(1,1) NOT FOR REPLICATION,
	ValuationProviderId int,
	JobStart datetime2, 
	JobEnd datetime2, 
	JobStats xml, 
)
go


