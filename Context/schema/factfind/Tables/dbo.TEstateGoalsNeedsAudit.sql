CREATE TABLE [dbo].[TEstateGoalsNeedsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GoalsAndNeeds] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[EstateGoalsNeedsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstateGo__Concu__1798699D] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEstateGoalsNeedsAudit] ADD CONSTRAINT [PK_TEstateGoalsNeedsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
