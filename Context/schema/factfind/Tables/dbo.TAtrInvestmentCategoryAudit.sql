CREATE TABLE [dbo].[TAtrInvestmentCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[AtrCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrInvestmentCategoryAudit_ConcurrencyId] DEFAULT ((1)),
[AtrInvestmentCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrInvestmentCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrInvestmentCategoryAudit] ADD CONSTRAINT [PK_TAtrInvestmentCategoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrInvestmentCategoryAudit_AtrInvestmentCategoryId_ConcurrencyId] ON [dbo].[TAtrInvestmentCategoryAudit] ([AtrInvestmentCategoryId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
