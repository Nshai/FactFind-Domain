CREATE TABLE [dbo].[TActivityTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Activity] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndClientId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[ActivityTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityT_StampDateTime_1__81] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TActivityTypeAudit] ADD CONSTRAINT [PK_TActivityTypeAudit_2__81] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TActivityTypeAudit_ActivityTypeId_ConcurrencyId] ON [dbo].[TActivityTypeAudit] ([ActivityTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
