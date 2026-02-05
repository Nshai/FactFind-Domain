CREATE TABLE [dbo].[TActivityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ActivityTypeId] [int] NULL,
[Activity] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[ActivityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityA_StampDateTime_1__81] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TActivityAudit] ADD CONSTRAINT [PK_TActivityAudit_2__81] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TActivityAudit_ActivityId_ConcurrencyId] ON [dbo].[TActivityAudit] ([ActivityId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
