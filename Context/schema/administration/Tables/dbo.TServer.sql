CREATE TABLE [dbo].[TServer]
(
[ServerId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[Protocol] [char] (8) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TServer_Protocol] DEFAULT ('http'),
[IPAddress] [char] (16) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TServer_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TServer] ADD CONSTRAINT [PK_TServer] PRIMARY KEY CLUSTERED  ([ServerId]) WITH (FILLFACTOR=80)
GO
