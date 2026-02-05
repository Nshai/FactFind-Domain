CREATE TABLE [dbo].[TPolicyMoneyInExtendedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyMoneyInId] [int] NOT NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PolicyMoneyInExtendedId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyMoneyInExtendedAudit] ADD CONSTRAINT [PK_TPolicyMoneyInExtendedAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
