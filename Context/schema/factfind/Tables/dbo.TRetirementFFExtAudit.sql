CREATE TABLE [dbo].[TRetirementFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ExistingMoneyPurchase] [bit] NULL,
[NonDisclosure] [bit] NULL,
[FinalSalary] [bit] NULL,
[ContractedOut] [bit] NULL,
[GoalsAndNeeds] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[NextSteps] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[RetirementFFExtId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetireme__Concu__5C77A3CF] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRetirementFFExtAudit] ADD CONSTRAINT [PK_TRetirementFFExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
