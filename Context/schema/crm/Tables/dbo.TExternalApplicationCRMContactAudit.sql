

CREATE TABLE [dbo].[TExternalApplicationCRMContactAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[PartyId] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContactAudit_CreatedDateTime] Default(GetDate()),
	[LastUpdatedDateTime] [datetime] NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContactAudit_LastUpdatedDateTime] Default(GetDate()),
	[LastSynchronisedDateTime] [datetime] NULL,
	[ValueSentToClient] [varchar](150) NULL,
	[IsForNewSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContactAudit_IsForNewSync] Default(0),
	[IsForUpdateSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContactAudit_IsForUpdateSync] Default(0),
	[IsForDeleteSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContactAudit_IsForDeleteSync] Default(0),
	[IsDeleted] bit NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContactAudit_IsDeleted] Default(0),
	[ExternalApplicationCRMContactId] [int] NOT NULL,
	[StampAction] [char] (1) NOT NULL,
	[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContactAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) NULL
)

ALTER TABLE [dbo].[TExternalApplicationCRMContactAudit] ADD CONSTRAINT [PK_TExternalApplicationCRMContactAudit] PRIMARY KEY CLUSTERED  ([AuditId], StampDateTime)
GO






