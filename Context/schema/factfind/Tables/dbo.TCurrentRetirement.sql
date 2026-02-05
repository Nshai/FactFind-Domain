CREATE TABLE [dbo].[TCurrentRetirement]
(
[CurrentRetirementId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCurrentR__Concu__011F1899] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCurrentRetirement_CRMContactId] ON [dbo].[TCurrentRetirement] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
