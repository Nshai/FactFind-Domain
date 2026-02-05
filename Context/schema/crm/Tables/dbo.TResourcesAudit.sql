CREATE TABLE [dbo].[TResourcesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AppointmentId] [int] NOT NULL,
[ResourceListId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TResourcesAudit_ConcurrencyId] DEFAULT ((1)),
[ResourcesId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TResourcesAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TResourcesAudit] ADD CONSTRAINT [PK_TResourcesAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
