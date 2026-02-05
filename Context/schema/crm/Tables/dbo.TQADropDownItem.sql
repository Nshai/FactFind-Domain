CREATE TABLE [dbo].[TQADropDownItem]
(
[QADropDownItemId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TQADropDow_ArchiveFg_1__60] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQADropDow_ConcurrencyId_2__60] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQADropDownItem] ADD CONSTRAINT [PK_TQADropDownItem_3__60] PRIMARY KEY NONCLUSTERED  ([QADropDownItemId]) WITH (FILLFACTOR=80)
GO
