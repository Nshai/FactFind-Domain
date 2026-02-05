CREATE TABLE [dbo].[TValRefBulkHoldingInEligibilityFlag]
(
[ValRefBulkHoldingInEligibilityFlagId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[InEligibilityFlag] [int] NULL,
[InEligibilityDescription] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TValRefBulkHoldingInEligibilityFlag] ADD CONSTRAINT [ValRefBulkHoldingInEligibilityFlagId]  
PRIMARY KEY NONCLUSTERED  ([ValRefBulkHoldingInEligibilityFlagId]) WITH (FILLFACTOR=80)