CREATE TABLE [dbo].[TRetirementFFExt]
(
[RetirementFFExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ExistingMoneyPurchase] [bit] NULL,
[NonDisclosure] [bit] NULL,
[FinalSalary] [bit] NULL,
[ContractedOut] [bit] NULL,
[GoalsAndNeeds] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[NextSteps] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetireme__Concu__08C03A61] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TRetirementFFExt_CRMContactId] ON [dbo].[TRetirementFFExt] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
