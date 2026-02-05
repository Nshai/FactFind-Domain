CREATE TABLE [dbo].[TRefTaskStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefTaskSt_ConcurrencyId_1__56] DEFAULT ((1)),
[RefTaskStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefTaskSt_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefTaskStatusAudit] ADD CONSTRAINT [PK_TRefTaskStatusAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefTaskStatusAudit_RefTaskStatusId_ConcurrencyId] ON [dbo].[TRefTaskStatusAudit] ([RefTaskStatusId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
