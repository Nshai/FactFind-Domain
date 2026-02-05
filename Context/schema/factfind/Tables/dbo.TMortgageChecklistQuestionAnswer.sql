CREATE TABLE [dbo].[TMortgageChecklistQuestionAnswer]
(
[MortgageChecklistQuestionAnswerId] [int] NOT NULL IDENTITY(1, 1),
[MortgageChecklistQuestionId] [int] NOT NULL,
[Answer] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageChecklistQuestionAnswer_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortgageChecklistQuestionAnswer] ADD CONSTRAINT [PK_TMortgageChecklistQuestionAnswer] PRIMARY KEY CLUSTERED  ([MortgageChecklistQuestionAnswerId])
GO
CREATE NONCLUSTERED INDEX [IX_TMortgageChecklistQuestionAnswer_CRMContactId] ON [dbo].[TMortgageChecklistQuestionAnswer] ([CRMContactId])
GO
