CREATE TABLE [dbo].[TCRMContactAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefCRMContactStatusId] [int] NULL,
[PersonId] [int] NULL,
[CorporateId] [int] NULL,
[TrustId] [int] NULL,
[AdvisorRef] [varchar] (50)  NULL,
[RefSourceOfClientId] [int] NULL,
[SourceValue] [varchar] (255)  NULL,
[Notes] [varchar] (8000)  NULL,
[ArchiveFg] [tinyint] NULL,
[LastName] [varchar] (50)  NULL,
[FirstName] [varchar] (50)  NULL,
[CorporateName] [varchar] (255)  NULL,
[DOB] [datetime] NULL,
[Postcode] [varchar] (10)  NULL,
[OriginalAdviserCRMId] [int] NOT NULL CONSTRAINT [DF_TCRMContactAudit_OriginalAdviserCRMId] DEFAULT ((0)),
[CurrentAdviserCRMId] [int] NOT NULL CONSTRAINT [DF_TCRMContactAudit_CurrentAdviserCRMId] DEFAULT ((0)),
[CurrentAdviserName] [varchar] (255)  NULL,
[CRMContactType] [tinyint] NOT NULL CONSTRAINT [DF_TCRMContactAudit_CRMContactType] DEFAULT ((0)),
[IndClientId] [int] NOT NULL,
[FactFindId] [int] NULL,
[InternalContactFG] [bit] NULL,
[RefServiceStatusId] [int] NULL,
[AdviserAssignedByUserId] [int] NULL,
[_ParentId] [int] NULL,
[_ParentTable] [varchar] (64)  NULL,
[_ParentDb] [varchar] (64)  NULL,
[_OwnerId] [int] NULL,
[MigrationRef] [varchar] (255)  NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TCRMContactAudit_CreatedDate] DEFAULT (getdate()),
[ExternalReference] [varchar] (60)  NULL,
[AdditionalRef] [varchar] (50)  NULL,
[CampaignDataId] [int] NULL,
[FeeModelId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCRMContactAudit_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[StampAction] [char] (1)  NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCRMContactAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255)  NULL,
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
ALTER TABLE [dbo].[TCRMContactAudit] ADD CONSTRAINT [PK_TCRMContactAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) 
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContactAudit_IndClientId_CrmContactId] ON [dbo].[TCRMContactAudit] ([IndClientId], [CRMContactId]) INCLUDE ([AuditId], [ExternalReference], [FirstName], [LastName], [StampDateTime])
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContactAudit_StampDateTime_CrmContactId] ON [dbo].[TCRMContactAudit] ([StampDateTime], [CRMContactId]) 
GO
CREATE NONCLUSTERED INDEX IX_TCRMContactAudit_CRMContactId ON [dbo].[TCRMContactAudit] ([CRMContactId])
GO
ALTER TABLE [dbo].[TCRMContactAudit] ADD CONSTRAINT [DF_TCRMContactAudit_IsDeleted] DEFAULT ((0)) FOR [IsDeleted]
GO
