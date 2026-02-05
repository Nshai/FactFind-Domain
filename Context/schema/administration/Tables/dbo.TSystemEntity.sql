CREATE TABLE [dbo].[TSystemEntity]
(
[SystemEntityId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[PrimaryInfo] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[SecondaryInfo] [varchar] (64) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TSystemEntity] ADD CONSTRAINT [PK_TSystemEntity] PRIMARY KEY NONCLUSTERED  ([SystemEntityId]) WITH (FILLFACTOR=80)
GO
