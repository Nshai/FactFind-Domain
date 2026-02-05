CREATE TABLE [dbo].[TRefAdviseFeeTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefAdviseFeeTypeId] [int] NOT NULL,
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[IsInitial] [bit] NOT NULL,
[IsOneOff] [bit] NOT NULL,
[IsRecurring] [bit] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAdviseFeeTypeAudit] ADD CONSTRAINT [PK_TRefAdviseFeeTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
