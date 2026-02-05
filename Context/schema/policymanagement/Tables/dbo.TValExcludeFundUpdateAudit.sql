CREATE TABLE [dbo].[TValExcludeFundUpdateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ValScheduleId] [int] NULL,
[ValGatingId] [int] NULL,
[ValExcludeFundUpdateId] [int] NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_Tmp_TValExcludeFundUpdateAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO