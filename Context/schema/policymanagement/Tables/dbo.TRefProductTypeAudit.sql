CREATE TABLE [dbo].[TRefProductTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProductTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IntellifloCode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RefProductGroupId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TRefProductTypeAudit_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefProductTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefProductTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefProductTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefProductTypeAudit] ADD CONSTRAINT [PK_TRefProductTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefProductTypeAudit_RefProductTypeId_ConcurrencyId] ON [dbo].[TRefProductTypeAudit] ([RefProductTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
