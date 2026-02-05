CREATE TABLE [dbo].[TValRefMatchingFlag]
(
[ValRefMatchingFlagId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[MatchingFlag] [int] NULL,
[MatchingDescription] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL
)
GO
