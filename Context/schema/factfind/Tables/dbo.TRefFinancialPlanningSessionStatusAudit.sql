CREATE TABLE [dbo].[TRefFinancialPlanningSessionStatusAudit]
(
[RefFinancialPlanningSessionStatusAuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RefFinancialPlanningSessionStatusId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF__TRefFinan__Stamp__71346041] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
