CREATE TABLE [dbo].[TLeadAdviserHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LeadId] [int] NOT NULL,
[AdviserId] [int] NOT NULL,
[ChangedByUserId] [int] NOT NULL,
[AssignedDate] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadAdviserHistoryAudit_ConcurrencyId] DEFAULT ((1)),
[LeadAdviserHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLeadAdviserHistoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLeadAdviserHistoryAudit] ADD CONSTRAINT [PK_TLeadAdviserHistoryAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
