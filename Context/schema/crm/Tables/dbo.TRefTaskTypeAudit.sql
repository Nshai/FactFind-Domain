CREATE TABLE [dbo].[TRefTaskTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefCategoryId] [int] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefTaskTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefTaskTy_StampDateTime_1__54] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefTaskTypeAudit] ADD CONSTRAINT [PK_TRefTaskTypeAudit_2__54] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefTaskTypeAudit_RefTaskTypeId_ConcurrencyId] ON [dbo].[TRefTaskTypeAudit] ([RefTaskTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
