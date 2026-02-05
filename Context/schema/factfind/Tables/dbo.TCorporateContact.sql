CREATE TABLE [dbo].[TCorporateContact]
(
[CorporateContactId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ContactId] [int] NOT NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Details] [varchar] (60) COLLATE Latin1_General_CI_AS NULL,
[isDefault] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCorporateContact_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporateContact_CRMContactId] ON [dbo].[TCorporateContact] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
