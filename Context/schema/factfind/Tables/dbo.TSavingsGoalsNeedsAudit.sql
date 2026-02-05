CREATE TABLE [dbo].[TSavingsGoalsNeedsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GoalsAndNeeds] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[SavingsGoalsNeedsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TSavingsG__Concu__13C7D8B9] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSavingsGoalsNeedsAudit] ADD CONSTRAINT [PK_TSavingsGoalsNeedsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
