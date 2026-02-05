CREATE TABLE [dbo].[TQADropDownList]
(
[QADropDownListId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[ArchiveFg] [bit] NOT NULL CONSTRAINT [DF_TQADropDow_ArchiveFg_3__60] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQADropDow_ConcurrencyId_5__60] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQADropDownList] ADD CONSTRAINT [PK_TQADropDownList_6__60] PRIMARY KEY NONCLUSTERED  ([QADropDownListId]) WITH (FILLFACTOR=80)
GO
