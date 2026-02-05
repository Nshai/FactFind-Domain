CREATE TABLE [dbo].[TNatureOfBusiness]
(
[NatureOfBusinessId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NatureOfBusiness] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TNatureOf__Concu__71DCD509] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TNatureOfBusiness_CRMContactId] ON [dbo].[TNatureOfBusiness] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
