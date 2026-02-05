
CREATE TABLE [dbo].[TExternalApplicationLead]
(
	[ExternalApplicationLeadId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[PartyId] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL CONSTRAINT [DF_TExternalApplicationLead_CreatedDateTime] Default(GetDate()),
	[LastUpdatedDateTime] [datetime] NOT NULL CONSTRAINT [DF_TExternalApplicationLead_LastUpdatedDateTime] Default(GetDate()),
	[LastSynchronisedDateTime] [datetime] NULL,
	[ValueSentToClient] [varchar](150) NULL,
	[IsForNewSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationLead_IsForNewSync] Default(0),
	[IsForUpdateSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationLead_IsForUpdateSync] Default(0),
	[IsForDeleteSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationLead_IsForDeleteSync] Default(0),
	[IsDeleted] bit NOT NULL CONSTRAINT [DF_TExternalApplicationLead_IsDeleted] Default(0)
)

ALTER TABLE [dbo].[TExternalApplicationLead] ADD CONSTRAINT [PK_TExternalApplicationLead] PRIMARY KEY NONCLUSTERED  ([ExternalApplicationLeadId])
GO

CREATE CLUSTERED INDEX [IX_TExternalApplicationLead_TenantId_UserId] 
	ON [dbo].[TExternalApplicationLead] ([TenantId], [UserId])
	--INCLUDE ([PartyId])
GO

ALTER TABLE [dbo].[TExternalApplicationLead] ADD CONSTRAINT [FK_TExternalApplicationLead_TCRMContact]
	FOREIGN KEY ([PartyId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO


