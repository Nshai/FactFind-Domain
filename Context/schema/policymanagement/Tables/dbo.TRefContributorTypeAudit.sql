CREATE TABLE [dbo].[TRefContributorTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefContributorTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[RetireFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefContributorTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefContributorTypeAudit] ADD CONSTRAINT [PK_TRefContributorTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefContributorTypeAudit_RefContributorTypeId_ConcurrencyId] ON [dbo].[TRefContributorTypeAudit] ([RefContributorTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
