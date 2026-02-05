CREATE TABLE [dbo].[TRefApplicationProviderCodeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefApplicationId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[CodeName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefApplicationProviderCodeAudit_ConcurrencyId] DEFAULT ((1)),
[RefApplicationProviderCodeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefApplicationProviderCodeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ProviderUrl] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefApplicationProviderCodeAudit] ADD CONSTRAINT [PK_TRefApplicationProviderCodeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefApplicationProviderCodeAudit_RefApplicationProviderCodeId_ConcurrencyId] ON [dbo].[TRefApplicationProviderCodeAudit] ([RefApplicationProviderCodeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
