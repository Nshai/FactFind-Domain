CREATE TABLE [dbo].[TAtrRetirement]
(
[AtrRetirementSyncId] [int] NULL,
[AtrRetirementId] [int] NOT NULL IDENTITY(1, 1),
[AtrQuestionGuid] [uniqueidentifier] NOT NULL,
[AtrAnswerGuid] [uniqueidentifier] NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRetirement_ConcurrencyId] DEFAULT ((1)),
[FreeTextAnswer] [varchar] (5000)  NULL
)
GO
ALTER TABLE [dbo].[TAtrRetirement] ADD CONSTRAINT [PK_TAtrRetirement] PRIMARY KEY CLUSTERED ([AtrRetirementId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrRetirement_CRMContactId] ON [dbo].[TAtrRetirement] ([CRMContactId])
GO
