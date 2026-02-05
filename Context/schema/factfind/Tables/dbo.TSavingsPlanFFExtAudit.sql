CREATE TABLE [dbo].[TSavingsPlanFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[InterestRate] [money] NULL,
[ConcurrencyId] [int] NOT NULL,
[SavingsPlanFFExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSavingsPlanFFExtAudit] ADD CONSTRAINT [PK_TSavingsPlanFFExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
