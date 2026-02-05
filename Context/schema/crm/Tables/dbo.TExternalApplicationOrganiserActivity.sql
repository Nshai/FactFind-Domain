
CREATE TABLE [dbo].[TExternalApplicationOrganiserActivity]
(
	[ExternalApplicationOrganiserActivityId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[OrganiserActivityId] [int] NOT NULL,
	[AppointmentId] [int] NULL,
	[CreatedDateTime] [datetime] NOT NULL CONSTRAINT [DF_TExternalApplicationOrganiserActivity_CreatedDateTime] Default(GetDate()),
	[LastUpdatedDateTime] [datetime] NOT NULL CONSTRAINT [DF_TExternalApplicationOrganiserActivity_LastUpdatedDateTime] Default(GetDate()),
	[LastSynchronisedDateTime] [datetime] NULL,
	[ExternalReference] nvarchar(max) NULL,
	[InternalReference] nvarchar(max) NULL,
	[IsForNewSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationOrganiserActivity_IsForNewSync] Default(0),
	[IsForUpdateSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationOrganiserActivity_IsForUpdateSync] Default(0),
	[IsForDeleteSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationOrganiserActivity_IsForDeleteSync] Default(0),
	[IsDeleted] bit NOT NULL CONSTRAINT [DF_TExternalApplicationOrganiserActivity_IsDeleted] Default(0),
	[SessionId] [uniqueidentifier] NULL,
	[RetryCount] int NOT NULL CONSTRAINT [DF_ExternalApplicationOrganiserActivity_RetryCount] Default(0)
)
GO
ALTER TABLE [dbo].[TExternalApplicationOrganiserActivity] ADD CONSTRAINT [PK_TExternalApplicationOrganiserActivity] PRIMARY KEY NONCLUSTERED  ([ExternalApplicationOrganiserActivityId])
GO