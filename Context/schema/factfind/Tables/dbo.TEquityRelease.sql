CREATE TABLE [dbo].[TEquityRelease]
(
[EquityReleaseId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[releaseEquity] [bit] NULL,
[reduceOwnership] [bit] NULL,
[existingPolicies] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEquityRelease_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEquityRelease] ADD CONSTRAINT [PK_TEquityRelease] PRIMARY KEY NONCLUSTERED  ([EquityReleaseId]) WITH (FILLFACTOR=80)
GO
