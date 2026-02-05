CREATE TABLE [dbo].[TMultiTieAuditBackup]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[PlanTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[MultiTieId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMultiTieAuditBackup] ADD CONSTRAINT [PK_TMultiTieAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
