CREATE TABLE [dbo].[TOpportunityStatusType]
(
[OpportunityStatusTypeId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32) COLLATE Latin1_General_CI_AS NULL,
[Archive] [bit] NULL CONSTRAINT [DF_TOpportunityStatusType_Archive] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunityStatusType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOpportunityStatusType] ADD CONSTRAINT [PK_TOpportunityStatusType] PRIMARY KEY NONCLUSTERED  ([OpportunityStatusTypeId])
GO
