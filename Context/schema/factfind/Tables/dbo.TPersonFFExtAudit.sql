CREATE TABLE [dbo].[TPersonFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[SharedFinances] [bit] NULL,
[AnybodyElsePresent] [bit] NULL,
[AnybodyElsePresentDetails] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[FinancialDependants] [bit] NULL,
[HasAssets] [bit] NULL,
[HasLiabilities] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[PersonFFExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPersonFFExtAudit] ADD CONSTRAINT [PK_TPersonFFExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
