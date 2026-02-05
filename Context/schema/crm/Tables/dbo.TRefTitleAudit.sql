CREATE TABLE [dbo].[TRefTitleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TitleName] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTitleAudit_ConcurrencyId] DEFAULT ((1)),
[RefTitleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefTitleAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefTitleAudit] ADD CONSTRAINT [PK_TRefTitleAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefTitleAudit_RefTitleId_ConcurrencyId] ON [dbo].[TRefTitleAudit] ([RefTitleId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
