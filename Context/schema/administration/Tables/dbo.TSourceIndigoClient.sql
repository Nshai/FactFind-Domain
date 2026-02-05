CREATE TABLE [dbo].[TSourceIndigoClient]
(
[SourceIndigoClientId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[SourceDatabase] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TSourceIndigoClient_SourceDatabase] DEFAULT ('')
)
GO
ALTER TABLE [dbo].[TSourceIndigoClient] ADD CONSTRAINT [PK_TSourceIndigoClient] PRIMARY KEY CLUSTERED  ([SourceIndigoClientId])
GO
