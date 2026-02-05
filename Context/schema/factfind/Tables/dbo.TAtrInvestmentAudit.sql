CREATE TABLE [dbo].[TAtrInvestmentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrQuestionGuid] [uniqueidentifier] NOT NULL,
[AtrAnswerGuid] [uniqueidentifier] NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TAtrInvestmentAudit_ConcurrencyId] DEFAULT ((1)),
[AtrInvestmentId] [int] NOT NULL,
[AtrInvestmentSyncId] [int] NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrInvestmentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255)  NULL,
[FreeTextAnswer] [varchar] (5000)  NULL
)
GO
ALTER TABLE [dbo].[TAtrInvestmentAudit] ADD CONSTRAINT [PK_TAtrInvestmentAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) 
GO
CREATE CLUSTERED INDEX [IDX_TAtrInvestmentAudit_AtrInvestmentId_ConcurrencyId] ON [dbo].[TAtrInvestmentAudit] ([AtrInvestmentId], [ConcurrencyId])
GO
