CREATE TABLE [dbo].[TRetirementGoalsNeedsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GoalsAndNeeds] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[RetirementGoalsNeedsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetireme__Concu__0E0EFF63] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRetirementGoalsNeedsAudit] ADD CONSTRAINT [PK_TRetirementGoalsNeedsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
