CREATE TABLE [dbo].[TValScheduleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Guid] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ScheduledLevel] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[RefGroupId] [int] NULL,
[ClientCRMContactId] [int] NULL,
[UserCredentialOption] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PortalCRMContactId] [int] NULL,
[StartDate] [datetime] NULL,
[Frequency] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsLocked] [bit] NOT NULL CONSTRAINT [DF_TValScheduleAudit_IsLocked] DEFAULT ((0)),
[UserNameForFileAccess] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PasswordForFileAccess] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Password2ForFileAccess] [varbinary] (4000) NULL,
[CreatedByUserId] [int] NULL ,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValScheduleAudit_ConcurrencyId] DEFAULT ((1)),
[ValScheduleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValScheduleAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValScheduleAudit] ADD CONSTRAINT [PK_TValScheduleAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TValScheduleAudit_ValScheduleId_ConcurrencyId] ON [dbo].[TValScheduleAudit] ([ValScheduleId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
