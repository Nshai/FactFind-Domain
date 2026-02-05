CREATE TABLE [dbo].[TRetirementNextStepsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NextSteps] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[RetirementNextStepsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetireme__Concu__11DF9047] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRetirementNextStepsAudit] ADD CONSTRAINT [PK_TRetirementNextStepsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
