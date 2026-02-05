CREATE TABLE [dbo].[TPractitioner]
(
[PractitionerId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PersonId] [int] NULL,
[CRMContactId] [int] NULL,
[TnCCoachId] [int] NULL,
[AuthorisedFG] [bit] NOT NULL,
[PIARef] [varchar] (255) NULL,
[AuthorisedDate] [datetime] NULL,
[ExperienceLevel] [tinyint] NULL,
[FSAReference] [varchar] (24) NULL,
[MultiTieFg] [bit] NOT NULL CONSTRAINT [DF_TPractitioner_MultiTieFg] DEFAULT ((0)),
[OffPanelFg] [bit] NOT NULL CONSTRAINT [DF_TPractitioner_OffPanelFg] DEFAULT ((0)),
[ManagerId] [int] NULL,
[PractitionerTypeId] [int] NULL,
[_ParentId] [int] NULL,
[_ParentTable] [varchar] (64) NULL,
[_ParentDb] [varchar] (64) NULL,
[_OwnerId] [int] NULL,
[Extensible] [varchar] (8000) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPractitioner_ConcurrencyId] DEFAULT ((1)),
[PictureName] [varchar] (120) NULL,
[JoinDate] [datetime] NULL,
[LeaveDate] [datetime] NULL,
[NINumber] [varchar] (255) NULL,
[SecondaryRef] [varchar] (255) NULL,
[DeceasedDate] [datetime] NULL,
[MigrationRef] [varchar] (255) NULL,
[ServicingAdministratorId] [int] NULL,
[ParaplannerUserId] [int] NULL
)
GO
ALTER TABLE [dbo].[TPractitioner] ADD CONSTRAINT [PK_TPractitioner_PractitionerId] PRIMARY KEY CLUSTERED  ([PractitionerId])
GO
CREATE NONCLUSTERED INDEX [IX_INCL_TPractitioner] ON [dbo].[TPractitioner] ([AuthorisedFG]) INCLUDE ([CRMContactId], [PractitionerId])
GO
CREATE NONCLUSTERED INDEX [IX_TPractitioner] ON [dbo].[TPractitioner] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IX_TPractitioner_IndClientId_TnCCoachId] ON [dbo].[TPractitioner] ([IndClientId], [TnCCoachId])
GO
CREATE NONCLUSTERED INDEX [IX_TPractitioner_CRMContactId] ON [dbo].[TPractitioner] ([PractitionerId], [CRMContactId], [IndClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TPractitioner_Practitioner_TnC_IndClient] ON [dbo].[TPractitioner] ([PractitionerId], [TnCCoachId], [CRMContactId])
GO
ALTER TABLE [dbo].[TPractitioner] WITH CHECK ADD CONSTRAINT [FK_TPractitioner_TPractitionerType] FOREIGN KEY ([PractitionerTypeId]) REFERENCES [dbo].[TPractitionerType] ([PractitionerTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_INCL_TPractitioner_CRMContactId] ON [dbo].[TPractitioner]([CRMContactId]) include (PractitionerId, AuthorisedFG,IndClientId)
go
