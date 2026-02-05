CREATE TABLE [dbo].[TRefUserTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[Url] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefUserTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefUserTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefUserTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefUserTypeAudit] ADD CONSTRAINT [PK_TRefUserTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefUserTypeAudit_RefUserTypeId_ConcurrencyId] ON [dbo].[TRefUserTypeAudit] ([RefUserTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
