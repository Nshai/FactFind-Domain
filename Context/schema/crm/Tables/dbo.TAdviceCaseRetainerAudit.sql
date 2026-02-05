CREATE TABLE [dbo].[TAdviceCaseRetainerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[RetainerId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseRetainerAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCaseRetainerId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseRetainerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseRetainerAudit] ADD CONSTRAINT [PK_TAdviceCaseRetainerAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviceCaseRetainerAudit_AdviceCaseRetainerId_ConcurrencyId] ON [dbo].[TAdviceCaseRetainerAudit] ([AdviceCaseRetainerId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
