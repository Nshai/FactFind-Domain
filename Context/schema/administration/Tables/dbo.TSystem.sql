CREATE TABLE [dbo].[TSystem]
(
[SystemId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (64) COLLATE Latin1_General_CI_AS NULL,
[SystemPath] [varchar] (256) COLLATE Latin1_General_CI_AS NULL,
[SystemType] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[ParentId] [int] NULL,
[Url] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[EntityId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TSystem_ConcurrencyId_1__56] DEFAULT ((1)),
[Order] [int] NOT NULL CONSTRAINT [DF_TSystem_Order_3__56] DEFAULT (0)
)
GO
ALTER TABLE [dbo].[TSystem] ADD CONSTRAINT [PK_TSystem_2__56] PRIMARY KEY NONCLUSTERED  ([SystemId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TSystem_ParentId] ON [dbo].[TSystem] ([ParentId]) WITH (FILLFACTOR=90)
GO
CREATE CLUSTERED INDEX [IDX_TSystem_SystemId_SystemPath] ON [dbo].[TSystem] ([SystemId], [SystemPath])
GO
ALTER TABLE [dbo].[TSystem] ADD CONSTRAINT [FK_TSystem_ParentId_SystemId] FOREIGN KEY ([ParentId]) REFERENCES [dbo].[TSystem] ([SystemId])
GO
