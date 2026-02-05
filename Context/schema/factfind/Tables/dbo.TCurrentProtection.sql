CREATE TABLE [dbo].[TCurrentProtection]
(
[CurrentProtectionId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCurrentP__Concu__7F36D027] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCurrentProtection_CRMContactId] ON [dbo].[TCurrentProtection] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
