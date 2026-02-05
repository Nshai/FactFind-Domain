CREATE TABLE [dbo].[TEquityReleaseAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[releaseEquity] [bit] NULL,
[reduceOwnership] [bit] NULL,
[existingPolicies] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEquityReleaseAudit_ConcurrencyId] DEFAULT ((1)),
[EquityReleaseId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEquityReleaseAudit] ADD CONSTRAINT [PK_TEquityReleaseAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
