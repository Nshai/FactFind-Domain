CREATE TABLE [dbo].[TSchemePlanTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SchemeTypeId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSchemePlanTypeAudit_ConcurrencyId] DEFAULT ((1)),
[SchemePlanTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSchemePlanTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefLicenceTypeId] [int] NOT NULL CONSTRAINT [DF__TSchemePl__RefLi__66EBDBF8] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSchemePlanTypeAudit] ADD CONSTRAINT [PK_TSchemePlanTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TSchemePlanTypeAudit_SchemePlanTypeId_ConcurrencyId] ON [dbo].[TSchemePlanTypeAudit] ([SchemePlanTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
