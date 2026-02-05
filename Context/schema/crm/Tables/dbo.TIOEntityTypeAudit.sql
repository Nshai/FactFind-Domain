CREATE TABLE [dbo].[TIOEntityTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EntityTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIOEntityTypeAudit_ConcurrencyId] DEFAULT ((1)),
[IOEntityTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIOEntityTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIOEntityTypeAudit] ADD CONSTRAINT [PK_TIOEntityTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TIOEntityTypeAudit_IOEntityTypeId_ConcurrencyId] ON [dbo].[TIOEntityTypeAudit] ([IOEntityTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
