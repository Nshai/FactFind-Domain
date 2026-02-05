CREATE TABLE [dbo].[TRetainerStatus]
(
[RetainerStatusId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RetainerId] [int] NOT NULL,
[Status] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[StatusNotes] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[StatusDate] [datetime] NOT NULL,
[UpdatedUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRetainerStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRetainerStatus] ADD CONSTRAINT [PK_TRetainerStatus] PRIMARY KEY NONCLUSTERED  ([RetainerStatusId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRetainerStatus_RetainerId] ON [dbo].[TRetainerStatus] ([RetainerId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TRetainerStatus] ADD CONSTRAINT [FK_TRetainerStatus_RetainerId_RetainerId] FOREIGN KEY ([RetainerId]) REFERENCES [dbo].[TRetainer] ([RetainerId])
GO
