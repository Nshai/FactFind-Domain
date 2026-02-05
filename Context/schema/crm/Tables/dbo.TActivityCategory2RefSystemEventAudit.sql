CREATE TABLE [dbo].[TActivityCategory2RefSystemEventAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ActivityCategoryId] [int] NOT NULL,
[RefSystemEventId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2RefSystemEventAudit_ConcurrencyId] DEFAULT ((1)),
[ActivityCategory2RefSystemEventId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityCategory2RefSystemEventAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TActivityCategory2RefSystemEventAudit] ADD CONSTRAINT [PK_TActivityCategory2RefSystemEventAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
