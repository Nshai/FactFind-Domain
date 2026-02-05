CREATE TABLE [dbo].[TObjectiveTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[Archived] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ObjectiveTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TObjectiveTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TObjectiveTypeAudit] ADD CONSTRAINT [PK_TObjectiveTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TObjectiveTypeAudit_ObjectiveTypeId_ConcurrencyId] ON [dbo].[TObjectiveTypeAudit] ([ObjectiveTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
