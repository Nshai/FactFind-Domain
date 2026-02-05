CREATE TABLE [dbo].[TAtrRefAccessOptionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRefAccessOptionAudit_ConcurrencyId] DEFAULT ((1)),
[AtrRefAccessOptionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrRefAccessOptionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrRefAccessOptionAudit] ADD CONSTRAINT [PK_TAtrRefAccessOptionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrRefAccessOptionAudit_AtrRefAccessOptionId_ConcurrencyId] ON [dbo].[TAtrRefAccessOptionAudit] ([AtrRefAccessOptionId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
