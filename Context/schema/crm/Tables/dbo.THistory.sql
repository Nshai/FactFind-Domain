CREATE TABLE [dbo].[THistory]
(
[HistoryId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NULL,
[HistoryDate] [datetime] NULL,
[Notes] [varchar] (2000)  NULL,
[Subject] [varchar] (250)  NULL,
[CRMContactId] [int] NOT NULL,
[RefHistoryTypeId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_THistory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[THistory] ADD CONSTRAINT [PK_THistory] PRIMARY KEY NONCLUSTERED  ([HistoryId])
GO
CREATE NONCLUSTERED INDEX [IDX_THistory_CRMContactId] ON [dbo].[THistory] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_THistory_RefHistoryTypeId] ON [dbo].[THistory] ([RefHistoryTypeId])
GO
ALTER TABLE [dbo].[THistory] WITH CHECK ADD CONSTRAINT [FK_THistory_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[THistory] ADD CONSTRAINT [FK_THistory_RefHistoryTypeId_RefHistoryTypeId] FOREIGN KEY ([RefHistoryTypeId]) REFERENCES [dbo].[TRefHistoryType] ([RefHistoryTypeId])
GO
