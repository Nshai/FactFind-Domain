CREATE TABLE [dbo].[TAtrRetirementAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrQuestionGuid] [uniqueidentifier] NOT NULL,
[AtrAnswerGuid] [uniqueidentifier] NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TAtrRetirementAudit_ConcurrencyId] DEFAULT ((1)),
[AtrRetirementId] [int] NOT NULL,
[AtrRetirementSyncId] [int] NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrRetirementAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255)  NULL,
[FreeTextAnswer] [varchar] (5000) NULL
)
GO
ALTER TABLE [dbo].[TAtrRetirementAudit] ADD CONSTRAINT [PK_TAtrRetirementAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TAtrRetirementAudit_AtrRetirementId_ConcurrencyId] ON [dbo].[TAtrRetirementAudit] ([AtrRetirementId], [ConcurrencyId])
GO
