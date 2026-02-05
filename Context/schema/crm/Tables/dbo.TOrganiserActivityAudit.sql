CREATE TABLE [dbo].[TOrganiserActivityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AppointmentId] [int] NULL,
[ActivityCategoryParentId] [int] NULL,
[ActivityCategoryId] [int] NULL,
[TaskId] [int] NULL,
[CompleteFG] [bit] NOT NULL CONSTRAINT [DF_TOrganiserActivityAudit_CompleteFG] DEFAULT ((0)),
[PolicyId] [int] NULL,
[FeeId] [int] NULL,
[RetainerId] [int] NULL,
[OpportunityId] [int] NULL,
[EventListActivityId] [int] NULL,
[CRMContactId] [int] NULL,
[JointCRMContactId] [int] NULL,
[IndigoClientId] [int] NULL,
[AdviceCaseId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOrganiserActivityAudit_ConcurrencyId] DEFAULT ((1)),
[OrganiserActivityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOrganiserActivityAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsRecurrence] [bit] NULL CONSTRAINT [DF__TOrganise__IsRec__6F412AD7] DEFAULT ((0)),
[RecurrenceSeriesId] [varchar] (250) COLLATE Latin1_General_CI_AS NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[CreatedByUserId] [int] NULL,
[UpdatedOn] [datetime] NULL,
[UpdatedByUserId] [int] NULL,
[PropertiesJson] [nvarchar] (4000) NULL
)
GO
ALTER TABLE [dbo].[TOrganiserActivityAudit] ADD CONSTRAINT [PK_TOrganiserActivityAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX IDC_TOrganiserActivityAudit_StampDateTime ON [dbo].[TOrganiserActivityAudit] ([StampDateTime]) INCLUDE ([OrganiserActivityId])
go
CREATE NONCLUSTERED INDEX IX_TOrganiserActivityAudit_AppointmentId ON [dbo].[TOrganiserActivityAudit] ([AppointmentId])
GO
create index IX_TOrganiserActivityAudit_OrganiserActivityId on TOrganiserActivityAudit (OrganiserActivityId)
GO
CREATE NONCLUSTERED INDEX IX_TOrganiserActivityAudit_TaskId ON [dbo].[TOrganiserActivityAudit] ([TaskId]) with (sort_in_tempdb = on)
GO
