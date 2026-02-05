CREATE TABLE [dbo].[TBudgetMiscellaneous]
(
[BudgetMiscellaneousId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[TotalEarnings] [money] NULL,
[Tax] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AnyAssets] [bit] NULL,
[AssetsNonDisclosure] [bit] NULL,
[AnyLiabilities] [bit] NULL,
[LiabilitiesRepayment] [bit] NULL,
[LiabilitiesWhyNot] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RepaymentDetails] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[LiabilitiesNonDisclosure] [bit] NULL,
[BudgetNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TBudgetMi__Concu__292D09F3] DEFAULT ((1)),
[AssetLiabilityNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[LiabilityNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBudgetMiscellaneous] ADD CONSTRAINT [PK_TBudgetMiscellaneous] PRIMARY KEY CLUSTERED  ([BudgetMiscellaneousId])
GO
CREATE NONCLUSTERED INDEX [IDX_TBudgetMiscellaneous_CRMContactId] ON [dbo].[TBudgetMiscellaneous] ([CRMContactId])
GO
ALTER TABLE [dbo].[TBudgetMiscellaneous] ADD CONSTRAINT UC_CRMContactId UNIQUE NONCLUSTERED (CRMContactId)
GO
