CREATE TABLE [dbo].[TBusinessInvestmentNeedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GoalDescription] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[EstimatedCosts] [money] NULL,
[CRMContactId] [int] NOT NULL,
[BusinessInvestmentNeedId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TBusiness__Concu__12149A71] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBusinessInvestmentNeedAudit] ADD CONSTRAINT [PK_TBusinessInvestmentNeedAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
