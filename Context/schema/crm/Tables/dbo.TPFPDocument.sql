CREATE TABLE [dbo].[TPFPDocument]
(
[PFPDocumentId] [int] NOT NULL IDENTITY(1, 1),
[Guid] [uniqueidentifier] NOT NULL,
[FileName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ContentLength] [int] NOT NULL,
[PFPSecureMessageId] [int] NULL,
[ClientPartyId] [int] NULL,
[TenantId] [int] NULL,
[ContentType] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPFPDocument] ADD CONSTRAINT [PK_TPFPDocument] PRIMARY KEY CLUSTERED  ([PFPDocumentId])
GO
ALTER TABLE [dbo].[TPFPDocument] ADD CONSTRAINT [FK_TPFPDocument_TCRMContact] FOREIGN KEY ([ClientPartyId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TPFPDocument] ADD CONSTRAINT [FK_TPFPDocument_TPFPSecureMessage] FOREIGN KEY ([PFPSecureMessageId]) REFERENCES [dbo].[TPFPSecureMessage] ([PFPSecureMessageId])
GO
