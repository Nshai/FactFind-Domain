

CREATE TABLE [dbo].[TExternalApplicationLeadAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[PartyId] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL CONSTRAINT [DF_TExternalApplicationLeadAudit_CreatedDateTime] Default(GetDate()),
	[LastUpdatedDateTime] [datetime] NOT NULL CONSTRAINT [DF_TExternalApplicationLeadAudit_LastUpdatedDateTime] Default(GetDate()),
	[LastSynchronisedDateTime] [datetime] NULL,
	[ValueSentToClient] [varchar](150) NULL,
	[IsForNewSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationLeadAudit_IsForNewSync] Default(0),
	[IsForUpdateSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationLeadAudit_IsForUpdateSync] Default(0),
	[IsForDeleteSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationLeadAudit_IsForDeleteSync] Default(0),
	[IsDeleted] bit NOT NULL CONSTRAINT [DF_TExternalApplicationLeadAudit_IsDeleted] Default(0),
	[ExternalApplicationLeadId] [int] NOT NULL,
	[StampAction] [char] (1) NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TExternalApplicationLeadAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) NULL
)

ALTER TABLE [dbo].[TExternalApplicationLeadAudit] ADD CONSTRAINT [PK_TExternalApplicationLeadAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
-- Speeds up DELETE in GDPR..spCustomAnonymiseClientListCrm on TExternalApplicationLeadAudit from 110s down to 30ms. Takes over 2 mins off each batch in Client Obfuscation
CREATE CLUSTERED INDEX IX_TExternalApplicationLeadAudit_PartyId ON dbo.TExternalApplicationLeadAudit (PartyId)
GO




