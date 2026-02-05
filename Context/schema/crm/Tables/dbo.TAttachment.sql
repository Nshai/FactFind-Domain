CREATE TABLE [dbo].[TAttachment]
(
[AttachmentId] [int] NOT NULL IDENTITY(1, 1),
[EmailId] [int] NOT NULL,
[AttachmentSize] [int] NOT NULL,
[AttachmentName] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AttachmentDocId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAttachment_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAttachment] ADD CONSTRAINT [PK_TAttachment] PRIMARY KEY CLUSTERED  ([AttachmentId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAttachment_EmailId] ON [dbo].[TAttachment] ([EmailId])
GO
ALTER TABLE [dbo].[TAttachment] ADD CONSTRAINT [FK_TAttachment_TEmail] FOREIGN KEY ([EmailId]) REFERENCES [dbo].[TEmail] ([EmailId])
GO
CREATE NONCLUSTERED INDEX [IX_TAttachment_AttachmentDocId_INCL] ON [dbo].[TAttachment] ([AttachmentDocId]) INCLUDE ([EmailId])
GO
