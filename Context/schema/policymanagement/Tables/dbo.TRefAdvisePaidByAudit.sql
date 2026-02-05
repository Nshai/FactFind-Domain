CREATE TABLE [dbo].[TRefAdvisePaidByAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefAdvisePaidById] [int] NOT NULL,
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[IsPaidByProvider] [bit] NOT NULL CONSTRAINT [DF_TRefAdvisePaidByAudit_IsPaidByProvider] DEFAULT ((0)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefAdvisePaidByAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAdvisePaidByAudit] ADD CONSTRAINT [PK_TRefAdvisePaidByAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
