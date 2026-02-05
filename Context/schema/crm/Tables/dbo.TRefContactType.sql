CREATE TABLE [dbo].[TRefContactType]
(
[RefContactTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ContactTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ArchiveFG] [tinyint] NOT NULL CONSTRAINT [DF_TRefContac_ArchiveFG_1__54] DEFAULT ((0)),
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefContac_ConcurrencyId_2__54] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefContactType] ADD CONSTRAINT [PK_TRefContactType_3__54] PRIMARY KEY NONCLUSTERED  ([RefContactTypeId]) WITH (FILLFACTOR=80)
GO
