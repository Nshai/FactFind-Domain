CREATE TABLE [dbo].[TRefSourceOfClient]
(
[RefSourceOfClientId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[SourceType] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFg] [tinyint] NULL,
[IndClientId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefSource_ConcurrencyId_1__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefSourceOfClient] ADD CONSTRAINT [PK_TRefSourceOfClient_2__54] PRIMARY KEY NONCLUSTERED  ([RefSourceOfClientId]) WITH (FILLFACTOR=80)
GO
