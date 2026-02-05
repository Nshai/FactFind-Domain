CREATE TABLE [dbo].[TNSBMessageOrderStore]
(
[MessageOrderId] [int] NOT NULL IDENTITY(1, 1),
[Key] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[MessageType] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL
)
GO
ALTER TABLE [dbo].[TNSBMessageOrderStore] ADD CONSTRAINT [PK_TNSBMessageOrderStore] PRIMARY KEY CLUSTERED  ([MessageOrderId])
GO
CREATE NONCLUSTERED INDEX [IDX_TNSBMessageOrderStore_Key_MessageType] ON [dbo].[TNSBMessageOrderStore] ([Key], [MessageType])
GO
CREATE NONCLUSTERED INDEX [IDX_TNSBMessageOrderStore_StampDateTime] ON [dbo].[TNSBMessageOrderStore] ([StampDateTime])
GO
