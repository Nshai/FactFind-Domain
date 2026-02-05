CREATE TABLE [dbo].[TValMatchingCriteria]
(
[ValMatchingCriteriaId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ValuationProviderId] [int] NULL,
[MatchingMask] [int] NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TValMatchingCriteria] ADD CONSTRAINT [PK_TValMatchingCriteria] PRIMARY KEY CLUSTERED  ([ValMatchingCriteriaId])
GO
