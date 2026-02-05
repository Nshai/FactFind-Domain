CREATE TABLE [dbo].[TRefValScheduleItemStatusAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefValScheduleItemStatusAudit_ConcurrencyId] DEFAULT ((1)),
[RefValScheduleItemStatusId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefValScheduleItemStatusAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefValScheduleItemStatusAudit] ADD CONSTRAINT [PK_TRefValScheduleItemStatusAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefValScheduleItemStatusAudit_RefValScheduleItemStatusId_ConcurrencyId] ON [dbo].[TRefValScheduleItemStatusAudit] ([RefValScheduleItemStatusId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
