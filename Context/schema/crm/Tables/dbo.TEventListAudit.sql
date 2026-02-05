CREATE TABLE [dbo].[TEventListAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[EventListTemplateId] [int] NOT NULL,
[OwnerUserId] [int] NOT NULL,
[StartDate] [datetime] NULL,
[ClientCRMContactId] [int] NOT NULL,
[JointClientCRMContactId] [int] NULL,
[PlanId] [int] NULL,
[AdviceCaseId][int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[EventListId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEventListAudit] ADD CONSTRAINT [PK_TEventListAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
