CREATE TABLE [dbo].[TRefContributionTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefContributionTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefContributionTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefContributionTypeAudit] ADD CONSTRAINT [PK_TRefContributionTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefContributionTypeAudit_RefContributionTypeId_ConcurrencyId] ON [dbo].[TRefContributionTypeAudit] ([RefContributionTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
