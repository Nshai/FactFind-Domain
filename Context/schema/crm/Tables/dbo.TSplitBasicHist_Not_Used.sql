CREATE TABLE [dbo].[TSplitBasicHist_Not_Used]
(
[SplitBasicHistId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PractCRMContactId] [int] NOT NULL,
[BasicSplitXML] [varchar] (8000) NOT NULL,
[DateSaved] [datetime] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSplitBasicHist_Not_Used_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TSplitBasicHist_Not_Used] ADD CONSTRAINT [PK_TSplitBasicHist_Not_Used] PRIMARY KEY NONCLUSTERED  ([SplitBasicHistId])
GO
CREATE NONCLUSTERED INDEX [IDX_TSplitBasicHist_PractCRMContactId] ON [dbo].[TSplitBasicHist_Not_Used] ([PractCRMContactId])
GO
ALTER TABLE [dbo].[TSplitBasicHist_Not_Used] WITH CHECK ADD CONSTRAINT [FK_TSplitBasicHist_PractCRMContactId_CRMContactId] FOREIGN KEY ([PractCRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
