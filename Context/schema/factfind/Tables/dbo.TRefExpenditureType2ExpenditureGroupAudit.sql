CREATE TABLE [dbo].[TRefExpenditureType2ExpenditureGroupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ConcurrencyId] [int] NOT NULL,
[RefExpenditureType2ExpenditureGroupId][int] NOT NULL,
[ExpenditureTypeId] [int] NOT NULL,
[ExpenditureGroupId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefExpenditureType2ExpenditureGroupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefExpenditureType2ExpenditureGroupAudit] ADD CONSTRAINT [PK_TRefExpenditureType2ExpenditureGroupAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
