CREATE TABLE [dbo].[TAdviceCaseStatusChangeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[AdviceCaseStatusIdFrom] [int] NOT NULL,
[AdviceCaseStatusIdTo] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusChangeAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCaseStatusChangeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseStatusChangeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseStatusChangeAudit] ADD CONSTRAINT [PK_TAdviceCaseStatusChangeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviceCaseStatusChangeAudit_AdviceCaseStatusChangeId_ConcurrencyId] ON [dbo].[TAdviceCaseStatusChangeAudit] ([AdviceCaseStatusChangeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
