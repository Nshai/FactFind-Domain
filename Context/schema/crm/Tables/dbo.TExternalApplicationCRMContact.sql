--2021-04-08 - KK
--This table is partitioned on TenantId in GB Region due to its size
--Currently it is not planned to be partitioned in any new regions
--Partitioning is a manual operation, please check with DBA for details

CREATE TABLE [dbo].[TExternalApplicationCRMContact]
(
	[ExternalApplicationCRMContactId] [int] NOT NULL IDENTITY(1, 1),
	[TenantId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[PartyId] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContact_CreatedDateTime] Default(GetDate()),
	[LastUpdatedDateTime] [datetime] NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContact_LastUpdatedDateTime] Default(GetDate()),
	[LastSynchronisedDateTime] [datetime] NULL,
	[ValueSentToClient] [varchar](150) NULL,
	[IsForNewSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContact_IsForNewSync] Default(0),
	[IsForUpdateSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContact_IsForUpdateSync] Default(0),
	[IsForDeleteSync] bit NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContact_IsForDeleteSync] Default(0),
	[IsDeleted] bit NOT NULL CONSTRAINT [DF_TExternalApplicationCRMContact_IsDeleted] Default(0)
)

ALTER TABLE [dbo].[TExternalApplicationCRMContact] ADD CONSTRAINT [PK_TExternalApplicationCRMContact] PRIMARY KEY NONCLUSTERED  ([ExternalApplicationCRMContactId], [TenantId])  -- ON ps_TExternalApplicationCRMContact_TenantId (TenantId) partitioned in the UK
GO

CREATE CLUSTERED INDEX [IX_TExternalApplicationCRMContact_UserId]
	ON [dbo].[TExternalApplicationCRMContact] ([UserId])  -- ON ps_TExternalApplicationCRMContact_TenantId (TenantId) partitioned in the UK
GO

ALTER TABLE [dbo].[TExternalApplicationCRMContact] ADD CONSTRAINT [FK_TExternalApplicationCRMContact_TCRMContact]
	FOREIGN KEY ([PartyId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO

--Speeds up DELETE in GDPR..spCustomAnonymiseClientListCrm on TExternalApplicationCrmContact from 99s to 300ms 100s of times (330 to 997 times in tests). Takes approx 2 mins off each batch in Client Obfuscation
CREATE INDEX IX_TExternalApplicationCrmContact_PartyId 
    ON dbo.TExternalApplicationCrmContact (PartyId) -- ON ps_TExternalApplicationCRMContact_TenantId (TenantId) partitioned in the UK
GO


CREATE INDEX IX_TExternalApplicationCrmContact_TenantId ON [TExternalApplicationCRMContact] (TenantId) 
INCLUDE (ExternalApplicationCRMContactId, PartyId) -- ON ps_TExternalApplicationCRMContact_TenantId (TenantId) partitioned in the UK
