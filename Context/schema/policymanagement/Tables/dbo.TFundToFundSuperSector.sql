CREATE TABLE [dbo].[TFundToFundSuperSector]
(
[FundToFundSuperSectorId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[FundId] [int] NOT NULL,
[FundSuperSectorId] [int] NOT NULL,
[IsFromFeed] [bit] NOT NULL,
[IsEquity] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TFundToFundSuperSector] ADD CONSTRAINT [PK_TFundToFundSuperSector] PRIMARY KEY CLUSTERED  ([FundToFundSuperSectorId])
GO
create nonclustered index IX_TFundToFundSuperSector_FundId on dbo.TFundToFundSuperSector (FundId) 
	Include (FundToFundSuperSectorId,FundSuperSectorId,IsFromFeed,IsEquity,ConcurrencyId)

