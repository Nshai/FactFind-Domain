CREATE TABLE [dbo].[TPlanValuation]
(
[PlanValuationId] [bigint] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[PlanValue] [money] NULL,
[PlanValueDate] [datetime] NULL,
[RefPlanValueTypeId] [int] NULL,
[WhoUpdatedValue] [int] NULL,
[WhoUpdatedDateTime] [datetime] NULL,
[SurrenderTransferValue] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanValuation_ConcurrencyId] DEFAULT ((1)),
[ValuationMigrationRef] [varchar] (255)  NULL
)
GO
ALTER TABLE [dbo].[TPlanValuation] ADD CONSTRAINT [PK_TPlanValuation] PRIMARY KEY NONCLUSTERED  ([PlanValuationId], [PolicyBusinessId])
GO
CREATE CLUSTERED INDEX [CLX_TPlanValuation_PolicyBusinessId] ON [dbo].[TPlanValuation] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPlanValuation] WITH CHECK ADD CONSTRAINT [FK_TPlanValuation_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPlanValuation] ADD CONSTRAINT [FK_TPlanValuation_RefPlanValueTypeId_RefPlanValueTypeId] FOREIGN KEY ([RefPlanValueTypeId]) REFERENCES [dbo].[TRefPlanValueType] ([RefPlanValueTypeId])
GO
