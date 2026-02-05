CREATE TABLE [dbo].[TEmail]
(
[EmailId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Subject] [varchar] (1000) NULL,
[SentDate] [datetime] NULL,
[EmailSize] [bigint] NULL,
[FromAddress] [varchar] (100) NULL,
[OriginalEmailDocId] [int] NULL,
[AttachmentCount] [int] NOT NULL CONSTRAINT [DF_TEmail_AttachmentCount] DEFAULT ((0)),
[OrganiserActivityId] [int] NOT NULL,
[OwnerPartyId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmail_ConcurrencyId] DEFAULT ((1)),
[HasHtmlBody] [bit] NULL,
[MessageDocId] [int] NULL,
[Source] [varchar] (50) NULL,
[SyncGuid] [uniqueidentifier] NULL
)
GO
ALTER TABLE [dbo].[TEmail] ADD CONSTRAINT [PK_TEmail] PRIMARY KEY CLUSTERED  ([EmailId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEmail_OrganiserActivityId] ON [dbo].[TEmail] ([OrganiserActivityId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEmail_OwnerPartyId] ON [dbo].[TEmail] ([OwnerPartyId]) INCLUDE ([OrganiserActivityId], [SentDate], [Subject])
GO
ALTER TABLE [dbo].[TEmail] ADD CONSTRAINT [FK_TEmail_TOrganiserActivity] FOREIGN KEY ([OrganiserActivityId]) REFERENCES [dbo].[TOrganiserActivity] ([OrganiserActivityId])
GO
ALTER TABLE [dbo].[TEmail] ADD CONSTRAINT [FK_TEmail_TPartyOwner] FOREIGN KEY ([OwnerPartyId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX IX_TEmail_SyncGuid ON [dbo].[TEmail] ([SyncGuid])
go