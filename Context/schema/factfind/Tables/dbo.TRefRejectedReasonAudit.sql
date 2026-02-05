CREATE TABLE [dbo].[TRefRejectedReasonAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefRejectedReasonId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL CONSTRAINT [DF_TRefRejectedReason_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefRejectedReasonAudit] ADD CONSTRAINT [PK_TRefRejectedReasonAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
