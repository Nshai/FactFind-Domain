CREATE TABLE [dbo].[TExternalApplicationOrganiserActivityAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[ExternalApplicationOrganiserActivityId] [int] NOT NULL,
	[TenantId] [int]  NULL,
	[UserId] [int]  NULL,
	[OrganiserActivityId] [int]  NULL,
	[AppointmentId] [int] NULL,
	[CreatedDateTime] [datetime]  NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[LastSynchronisedDateTime] [datetime] NULL,
	[ExternalReference] nvarchar(max) NULL,
	[IsForNewSync] bit  NULL,
	[IsForUpdateSync] bit   NULL,
	[IsForDeleteSync] bit   NULL,
	[IsDeleted] bit NULL,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TExternalApplicationOrganiserActivityAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
	[InternalReference] nvarchar(max) NULL,
	[SessionId] [uniqueidentifier] NULL,
	[RetryCount] int NOT NULL CONSTRAINT [DF_ExternalApplicationOrganiserActivityAudit_RetryCount] Default(0)
)
GO
ALTER TABLE [dbo].[TExternalApplicationOrganiserActivityAudit] ADD CONSTRAINT [PK_TExternalApplicationOrganiserActivityAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO