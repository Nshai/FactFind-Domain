CREATE TABLE [dbo].[TAdviceCaseFileCheckAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[FileCheckMiniId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseFileCheckAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCaseFileCheckId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseFileCheckAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseFileCheckAudit] ADD CONSTRAINT [PK_TAdviceCaseFileCheckAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviceCaseFileCheckAudit_AdviceCaseFileCheckId_ConcurrencyId] ON [dbo].[TAdviceCaseFileCheckAudit] ([AdviceCaseFileCheckId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
