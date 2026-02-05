CREATE TABLE [dbo].[TValRefEligibilityFlag]
(
[ValRefEligibilityFlagId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EligibilityFlag] [int] NULL,
[EligibilityDescription] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[InEligibilityDescription] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[EligibilityLevel] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TValRefEligibilityFlag] ADD CONSTRAINT [PK_TValRefEligibilityFlag] PRIMARY KEY CLUSTERED  ([ValRefEligibilityFlagId])
GO


