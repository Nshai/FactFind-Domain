CREATE TABLE [dbo].[TAdviceCaseHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[ChangeType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[StatusId] [int] NULL,
[PractitionerId] [int] NULL,
[ChangedByUserId] [int] NULL,
[StatusDate] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseHistoryAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCaseHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseHistoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseHistoryAudit] ADD CONSTRAINT [PK_TAdviceCaseHistoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviceCaseHistoryAudit_AdviceCaseHistoryId_ConcurrencyId] ON [dbo].[TAdviceCaseHistoryAudit] ([AdviceCaseHistoryId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
