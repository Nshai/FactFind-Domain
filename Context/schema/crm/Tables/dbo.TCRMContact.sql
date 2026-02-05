CREATE TABLE [dbo].[TCRMContact]
(
[CRMContactId] [int] NOT NULL IDENTITY(1, 1),
[RefCRMContactStatusId] [int] NULL,
[PersonId] [int] NULL,
[CorporateId] [int] NULL,
[TrustId] [int] NULL,
[AdvisorRef] [varchar] (50) NULL,
[RefSourceOfClientId] [int] NULL,
[SourceValue] [varchar] (255) NULL,
[Notes] [varchar] (8000) NULL,
[ArchiveFg] [tinyint] NULL,
[LastName] [varchar] (50) NULL,
[FirstName] [varchar] (50) NULL,
[CorporateName] [varchar] (255) NULL,
[DOB] [datetime] NULL,
[Postcode] [varchar] (10) NULL,
[OriginalAdviserCRMId] [int] NOT NULL CONSTRAINT [DF_TCRMContact_OriginalAdviserCRMId] DEFAULT ((0)),
[CurrentAdviserCRMId] [int] NOT NULL CONSTRAINT [DF_TCRMContact_CurrentAdviserCRMId] DEFAULT ((0)),
[CurrentAdviserName] [varchar] (255)  NULL,
[CRMContactType] [tinyint] NOT NULL CONSTRAINT [DF_TCRMContact_CRMContactType] DEFAULT ((0)),
[IndClientId] [int] NOT NULL,
[FactFindId] [int] NULL,
[InternalContactFG] [bit] NULL,
[RefServiceStatusId] [int] NULL,
[MigrationRef] [varchar] (255)  NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TCRMContact_CreatedDate] DEFAULT (getdate()),
[ExternalReference] [varchar] (60) NULL,
[CampaignDataId] [int] NULL,
[AdditionalRef] [varchar] (50)  NULL,
[AdviserAssignedByUserId] [int] NULL,
[_ParentId] [int] NULL,
[_ParentTable] [varchar] (64) NULL,
[_ParentDb] [varchar] (64) NULL,
[_OwnerId] [int] NULL,
[FeeModelId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCRMContact_ConcurrencyId] DEFAULT ((1)),
[ServiceStatusStartDate] [datetime] NULL,
[ClientTypeId] [int] NULL,
[IsHeadOfFamilyGroup] [BIT] NULL,
[FamilyGroupCreationDate] [DATETIME] NULL,
[IsDeleted] [tinyint] NOT NULL,
[GroupId] [int] NULL,
[RefClientSegmentId] [int] NULL,
[ClientSegmentStartDate] [datetime] NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

ALTER TABLE [dbo].[TCRMContact] ADD CONSTRAINT [PK_TCRMContact] PRIMARY KEY NONCLUSTERED  ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IX_INCL_TCRMContact_ArchiveFg_IndClientId] ON [dbo].[TCRMContact]([IndClientId]) INCLUDE ([AdditionalRef],[AdvisorRef],[CampaignDataId],[CorporateName],[CRMContactId],[CRMContactType],[CurrentAdviserCRMId],[CurrentAdviserName],[DOB],[ExternalReference],[FirstName],[InternalContactFG],[LastName],[RefCRMContactStatusId],[ArchiveFg],[_OwnerId]) 
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContact_ArchiveFg_IndClientId] ON [dbo].[TCRMContact] ([ArchiveFg], [IndClientId]) INCLUDE ([_OwnerId], [AdvisorRef], [CorporateName], [CRMContactId], [CRMContactType], [CurrentAdviserName], [ExternalReference], [FirstName], [LastName], [RefCRMContactStatusId])
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContact_CorporateId] ON [dbo].[TCRMContact] ([CorporateId])
GO
CREATE NONCLUSTERED INDEX [IX_TCRMContact_CorporateName] ON [dbo].[TCRMContact] ([CorporateName], [CRMContactId])
GO
CREATE NONCLUSTERED INDEX [ix_tmp1] ON [dbo].[TCRMContact] ([CRMContactId]) INCLUDE ([AdvisorRef], [CorporateName], [CRMContactType], [ExternalReference], [FirstName], [LastName])
GO
CREATE NONCLUSTERED INDEX [IX_TCRMcontact_CRMContactId_CurrentAdviserCRMId_PersonId] ON [dbo].[TCRMContact] ([CRMContactId], [CurrentAdviserCRMId], [PersonId])
GO
CREATE NONCLUSTERED INDEX [ix_tmp2] ON [dbo].[TCRMContact] ([CRMContactId], [IndClientId]) INCLUDE ([_OwnerId])
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContact_Id_FirstName_LastName_CorporateName_IndClientId] ON [dbo].[TCRMContact] ([FirstName], [LastName], [CorporateName], [IndClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TCRMContact_IndClientId_CRMContactId] ON [dbo].[TCRMContact] ([IndClientId], [CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContact_UserId_LastName_FirstName_CorporateName] ON [dbo].[TCRMContact] ([IndClientId], [LastName], [FirstName], [CorporateName], [CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IX_TCRMContact_IndClientId_RefServiceStatusId] ON [dbo].[TCRMContact] ([IndClientId], [RefServiceStatusId])
GO
CREATE NONCLUSTERED INDEX [IDX_LastName_DOB_CRMContactId] ON [dbo].[TCRMContact] ([LastName], [DOB], [CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IX_TCRMContact_MigrationRef_IndClient] ON [dbo].[TCRMContact] ([MigrationRef], [IndClientId])
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContact_PersonId] ON [dbo].[TCRMContact] ([PersonId])
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContact_RefCRMContactStatusId] ON [dbo].[TCRMContact] ([RefCRMContactStatusId])
GO
CREATE NONCLUSTERED INDEX [IX_INCL_TCRMContact_RefCRMContactStatusId_ArchiveFg_IndClientId_PersonId_OwnerId] 
	ON [dbo].[TCRMContact] ([RefCRMContactStatusId], [ArchiveFg], [IndClientId], [PersonId],[_OwnerId]) 
	INCLUDE ([CorporateName], [CRMContactId], [CurrentAdviserCRMId], [ExternalReference], [FirstName], [LastName], [RefServiceStatusId], [CreatedDate])
GO
CREATE NONCLUSTERED INDEX [IX_TCRMContact_RefCRMContactStatusId_CurrentAdviserCRMId_CRMContactType_CreatedDate] ON [dbo].[TCRMContact] ([RefCRMContactStatusId], [CurrentAdviserCRMId], [CRMContactType], [CreatedDate]) INCLUDE ([ArchiveFg])
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContact_TrustId] ON [dbo].[TCRMContact] ([TrustId])
GO
ALTER TABLE [dbo].[TCRMContact] WITH CHECK ADD CONSTRAINT [FK_TCRMContact_TCorporate] FOREIGN KEY ([CorporateId]) REFERENCES [dbo].[TCorporate] ([CorporateId])
GO
ALTER TABLE [dbo].[TCRMContact] WITH CHECK ADD CONSTRAINT [FK_TCRMContact_TPerson] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[TPerson] ([PersonId])
GO
ALTER TABLE [dbo].[TCRMContact] ADD CONSTRAINT [FK_TCRMContact_TRefCRMContactStatus] FOREIGN KEY ([RefCRMContactStatusId]) REFERENCES [dbo].[TRefCRMContactStatus] ([RefCRMContactStatusId])
GO
ALTER TABLE [dbo].[TCRMContact] ADD CONSTRAINT [FK_TCRMContact_TTrust] FOREIGN KEY ([TrustId]) REFERENCES [dbo].[TTrust] ([TrustId])
GO
CREATE NONCLUSTERED INDEX IX_TCRMContact_CampaignDataId ON [dbo].[TCRMContact] ([CampaignDataId]) 
GO
ALTER TABLE [dbo].[TCRMContact] ADD CONSTRAINT [DF_TCRMContact_IsDeleted] DEFAULT ((0)) FOR [IsDeleted]
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContact_GroupId] ON [dbo].[TCRMContact] ([GroupId])
GO