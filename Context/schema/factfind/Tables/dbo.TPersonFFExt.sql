CREATE TABLE [dbo].[TPersonFFExt]
(
[PersonFFExtId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[SharedFinances] [bit] NULL,
[AnybodyElsePresent] [bit] NULL,
[AnybodyElsePresentDetails] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[FinancialDependants] [bit] NULL,
[HasAssets] [bit] NULL,
[HasLiabilities] [bit] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TPersonFFExt] ADD CONSTRAINT [PK_TPersonFFExt] PRIMARY KEY CLUSTERED  ([PersonFFExtId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPersonFFExt_CRMContactId] ON [dbo].[TPersonFFExt] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TPersonFFExt_CRMContactId] ON [dbo].[TPersonFFExt] ([CRMContactId])
GO
