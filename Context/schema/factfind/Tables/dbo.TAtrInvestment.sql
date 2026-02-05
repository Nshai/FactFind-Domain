CREATE TABLE [dbo].[TAtrInvestment]
(
[AtrInvestmentSyncId] [int] NULL,
[AtrInvestmentId] [int] NOT NULL IDENTITY(1, 1),
[AtrQuestionGuid] [uniqueidentifier] NOT NULL,
[AtrAnswerGuid] [uniqueidentifier] NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrInvestment_ConcurrencyId] DEFAULT ((1)),
[FreeTextAnswer] [varchar] (5000)  NULL
)
GO
ALTER TABLE [dbo].[TAtrInvestment] ADD CONSTRAINT [PK_TAtrInvestment] PRIMARY KEY CLUSTERED ([AtrInvestmentId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrInvestment_CRMContactId] ON [dbo].[TAtrInvestment] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX IX_TAtrInvestment_AtrQuestionGuid ON [dbo].[TAtrInvestment] ([AtrQuestionGuid]) INCLUDE ([AtrInvestmentId],[CRMContactId]) 
GO