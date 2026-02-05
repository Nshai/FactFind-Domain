CREATE TABLE [dbo].[TRefHistoryType]
(
[RefHistoryTypeId] [int] NOT NULL IDENTITY(1, 1),
[TypeName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ArchiveFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefHistor_ConcurrencyId_1__58] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefHistoryType] ADD CONSTRAINT [PK_TRefHistoryType_2__58] PRIMARY KEY NONCLUSTERED  ([RefHistoryTypeId]) WITH (FILLFACTOR=80)
GO
