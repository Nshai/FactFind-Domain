CREATE TABLE [dbo].[TAssetNotes]
(
[AssetNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[EquityAvailableYN] [bit] NULL,
[EquityAvailableDetails] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TAssetNot__Concu__1466F737] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TAssetNotes_CRMContactId] ON [dbo].[TAssetNotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
