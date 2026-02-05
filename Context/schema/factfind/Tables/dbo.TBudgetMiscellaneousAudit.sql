CREATE TABLE [dbo].[TBudgetMiscellaneousAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
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
[CRMContactId] [int] NOT NULL,
[BudgetMiscellaneousId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TBudgetMi__Concu__7CE47361] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AssetLiabilityNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[LiabilityNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBudgetMiscellaneousAudit] ADD CONSTRAINT [PK_TBudgetMiscellaneousAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
