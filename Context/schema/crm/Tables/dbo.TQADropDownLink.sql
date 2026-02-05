CREATE TABLE [dbo].[TQADropDownLink]
(
[QADropDownLinkId] [int] NOT NULL IDENTITY(1, 1),
[QADropDownListId] [int] NOT NULL,
[QADropDownItemId] [int] NOT NULL,
[IndClientId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TQADropDow_ArchiveFg_2__60] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQADropDow_ConcurrencyId_3__60] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQADropDownLink] ADD CONSTRAINT [PK_TQADropDownLink_4__60] PRIMARY KEY NONCLUSTERED  ([QADropDownLinkId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQADropDownLink_QADropDownItemId] ON [dbo].[TQADropDownLink] ([QADropDownItemId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQADropDownLink_QADropDownListId] ON [dbo].[TQADropDownLink] ([QADropDownListId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TQADropDownLink] ADD CONSTRAINT [FK_TQADropDownLink_QADropDownItemId_QADropDownItemId] FOREIGN KEY ([QADropDownItemId]) REFERENCES [dbo].[TQADropDownItem] ([QADropDownItemId])
GO
ALTER TABLE [dbo].[TQADropDownLink] ADD CONSTRAINT [FK_TQADropDownLink_QADropDownListId_QADropDownListId] FOREIGN KEY ([QADropDownListId]) REFERENCES [dbo].[TQADropDownList] ([QADropDownListId])
GO
