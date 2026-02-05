CREATE TABLE [dbo].[TOpportunityFee]
(
[OpportunityFeeId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NULL,
[FeeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunityFee_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOpportunityFee] ADD CONSTRAINT [PK_TOpportunityFee] PRIMARY KEY NONCLUSTERED  ([OpportunityFeeId])
GO
