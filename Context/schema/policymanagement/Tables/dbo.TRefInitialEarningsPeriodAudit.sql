CREATE TABLE [dbo].[TRefInitialEarningsPeriodAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[InitialEarningsPeriod] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefInitialEarningsPeriodAudit_ConcurrencyId] DEFAULT ((0)),
[RefInitialEarningsPeriodId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefInitialEarningsPeriodAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefInitialEarningsPeriodAudit] ADD CONSTRAINT [PK_TRefInitialEarningsPeriodAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
