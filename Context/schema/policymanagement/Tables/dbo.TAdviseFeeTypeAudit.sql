CREATE TABLE [dbo].[TAdviseFeeTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NULL,
[IsArchived] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[AdviseFeeTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IsRecurring] [bit] NOT NULL CONSTRAINT [DF_TAdviseFeeTypeAudit_IsRecurring] DEFAULT ((0)),
[GroupId] [int] NULL,
[RefAdviseFeeTypeId] [int] NULL,
[IsSystemDefined] [bit] NULL
)
GO
ALTER TABLE [dbo].[TAdviseFeeTypeAudit] ADD CONSTRAINT [PK_TAdviseFeeTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAdviseFeeTypeAudit_AdviseFeeTypeId] ON [dbo].[TAdviseFeeTypeAudit] ([AdviseFeeTypeId])
GO
