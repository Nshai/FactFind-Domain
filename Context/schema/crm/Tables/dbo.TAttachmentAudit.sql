CREATE TABLE [dbo].[TAttachmentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EmailId] [int] NOT NULL,
[AttachmentSize] [int] NOT NULL,
[AttachmentName] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[AttachmentDocId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[AttachmentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAttachmentAudit] ADD CONSTRAINT [PK_TAttachmentAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
