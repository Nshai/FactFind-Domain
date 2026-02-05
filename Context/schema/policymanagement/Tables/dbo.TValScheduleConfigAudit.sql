CREATE TABLE [dbo].[TValScheduleConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[ScheduleStartTime] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IsEnabled] [bit] NOT NULL CONSTRAINT [DF_TValScheduleConfigAudit_IsEnabled] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValScheduleConfigAudit_ConcurrencyId] DEFAULT ((1)),
[ValScheduleConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValScheduleConfigAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValScheduleConfigAudit] ADD CONSTRAINT [PK_TValScheduleConfigAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TValScheduleConfigAudit_ValScheduleConfigId_ConcurrencyId] ON [dbo].[TValScheduleConfigAudit] ([ValScheduleConfigId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
