CREATE TABLE [dbo].[TExpenditureChangeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ExpenditureChangeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[IsRise] [bit] NOT NULL,
[Amount] [money] NOT NULL,
[Frequency] [varchar] (16) NOT NULL,
[StartDate] [date] NULL,
[Description] [varchar] (3000) NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TExpenditureChangeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TExpenditureChangeAudit] ADD CONSTRAINT [PK_TExpenditureChangeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
