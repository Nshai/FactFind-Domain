CREATE TABLE [dbo].[TIncomeChangeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IncomeChangeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[IsRise] [bit] NOT NULL,
[Amount] [money] NULL,
[Frequency] [varchar] (16) NOT NULL,
[StartDate] [date] NULL,
[Description] [varchar] (255) NULL,
[IsOwnerSelected] [bit] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIncomeChangeAudit_StampDateTime] DEFAULT (GETDATE()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TIncomeChangeAudit] ADD CONSTRAINT [PK_TIncomeChangeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
