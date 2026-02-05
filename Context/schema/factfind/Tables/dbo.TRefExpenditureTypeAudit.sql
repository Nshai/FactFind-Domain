CREATE TABLE [dbo].[TRefExpenditureTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ConcurrencyId] [int] NOT NULL,
[RefExpenditureGroupId] [tinyint] NOT NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Ordinal] [tinyint] NOT NULL,
[RefExpenditureTypeId] [int] NULL,
[Attributes] [nvarchar] (MAX) NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefExpenditureTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefExpenditureTypeAudit] ADD CONSTRAINT [PK_TRefExpenditureTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
