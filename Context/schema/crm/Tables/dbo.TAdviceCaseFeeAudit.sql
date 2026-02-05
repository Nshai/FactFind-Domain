CREATE TABLE [dbo].[TAdviceCaseFeeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[FeeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseFeeAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCaseFeeId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseFeeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseFeeAudit] ADD CONSTRAINT [PK_TAdviceCaseFeeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviceCaseFeeAudit_AdviceCaseFeeId_ConcurrencyId] ON [dbo].[TAdviceCaseFeeAudit] ([AdviceCaseFeeId], [ConcurrencyId])
GO
