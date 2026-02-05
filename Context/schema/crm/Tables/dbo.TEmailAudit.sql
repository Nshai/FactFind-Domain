CREATE TABLE [dbo].[TEmailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Subject] [varchar] (1000) NULL,
[SentDate] [datetime] NULL,
[EmailSize] [bigint] NULL,
[FromAddress] [varchar] (100) NULL,
[OriginalEmailDocId] [int] NULL,
[AttachmentCount] [int] NOT NULL,
[OrganiserActivityId] [int] NOT NULL,
[OwnerPartyId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailAudit_ConcurrencyId] DEFAULT ((1)),
[EmailId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) NULL,
[HasHtmlBody] [bit] NULL,
[MessageDocId] [int] NULL,
[Source] [varchar] (50) NULL,
[SyncGuid] [uniqueidentifier] NULL
)
GO
ALTER TABLE [dbo].[TEmailAudit] ADD CONSTRAINT [PK_TEmailAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
