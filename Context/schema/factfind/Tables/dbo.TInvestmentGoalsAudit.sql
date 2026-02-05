CREATE TABLE [dbo].[TInvestmentGoalsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Amount] [money] NULL,
[Frequency] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[Finishing] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AnnualIncrease] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[GoalTerm] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[InvestmentGoalsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TInvestme__Concu__6FBF826D] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentGoalsAudit] ADD CONSTRAINT [PK_TInvestmentGoalsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
