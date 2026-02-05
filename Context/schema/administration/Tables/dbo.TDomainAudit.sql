CREATE TABLE [dbo].[TDomainAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[DomainId] [int] NOT NULL,
[GroupId] [int] NOT NULL,
[Host] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Application] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDomainAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDomainAudit] ADD CONSTRAINT [PK_TDomainAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO