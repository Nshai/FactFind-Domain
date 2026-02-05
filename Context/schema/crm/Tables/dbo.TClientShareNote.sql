CREATE TABLE [dbo].[TClientShareNote]
(
[ClientShareNoteId] [int] NOT NULL IDENTITY(1, 1),
[Notes] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[LastEditedBy] [int] NULL,
[LastEditedDate] [datetime] NULL,
[ClientShareId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TClientShareNote_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TClientShareNote] ADD CONSTRAINT [PK_TClientShareNote] PRIMARY KEY CLUSTERED  ([ClientShareNoteId])
GO
CREATE NONCLUSTERED INDEX [idx_ClientShareId] ON [dbo].[TClientShareNote] ([ClientShareId])
GO
CREATE NONCLUSTERED INDEX [idx_CreatedBy] ON [dbo].[TClientShareNote] ([CreatedBy])
GO
CREATE NONCLUSTERED INDEX [idx_LastEditedBy] ON [dbo].[TClientShareNote] ([LastEditedBy])
GO
CREATE NONCLUSTERED INDEX [idx_TenantId] ON [dbo].[TClientShareNote] ([TenantId])
GO
