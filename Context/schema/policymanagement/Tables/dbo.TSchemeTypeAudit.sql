CREATE TABLE [dbo].[TSchemeTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SchemeTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsRetired] [bit] NOT NULL CONSTRAINT [DF_TSchemeTypeAudit_IsRetired] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSchemeTypeAudit_ConcurrencyId] DEFAULT ((1)),
[SchemeTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSchemeTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefLicenceTypeId] [int] NOT NULL CONSTRAINT [DF__TSchemeTy__RefLi__6CA4B54E] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSchemeTypeAudit] ADD CONSTRAINT [PK_TSchemeTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TSchemeTypeAudit_SchemeTypeId_ConcurrencyId] ON [dbo].[TSchemeTypeAudit] ([SchemeTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
