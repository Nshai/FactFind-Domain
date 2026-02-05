CREATE TABLE [dbo].[TBatchFileProcessAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBatchFileProcessAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[BatchFileProcessId] [int] NOT NULL,
[Name] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[NotificationEmails] [nvarchar](max) NULL,
[ApplicationLinkId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NULL,
)
GO
ALTER TABLE [dbo].[TBatchFileProcessAudit] ADD CONSTRAINT [PK_TBatchFileProcessAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
