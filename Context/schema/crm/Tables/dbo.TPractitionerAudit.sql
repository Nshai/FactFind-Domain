CREATE TABLE [dbo].[TPractitionerAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndClientId] [int] NOT NULL,
[PersonId] [int] NULL,
[CRMContactId] [int] NULL,
[TnCCoachId] [int] NULL,
[AuthorisedFG] [bit] NOT NULL,
[PIARef] [varchar] (255) NULL,
[AuthorisedDate] [datetime] NULL,
[ExperienceLevel] [tinyint] NULL,
[_ParentId] [int] NULL,
[_ParentTable] [varchar] (64) NULL,
[_ParentDb] [varchar] (64) NULL,
[_OwnerId] [int] NULL,
[FSAReference] [varchar] (24) NULL,
[MultiTieFg] [bit] NOT NULL CONSTRAINT [DF_TPractitionerAudit_MultiTieFg] DEFAULT ((0)),
[OffPanelFg] [bit] NULL CONSTRAINT [DF_TPractitionerAudit_OffPanelFg] DEFAULT ((0)),
[ManagerId] [int] NULL,
[PractitionerTypeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPractitionerAudit_ConcurrencyId] DEFAULT ((1)),
[PractitionerId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPractitionerAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
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
ALTER TABLE [dbo].[TPractitionerAudit] ADD CONSTRAINT [PK_TPractitionerAudit_AuditId] PRIMARY KEY CLUSTERED  ([AuditId])
GO
