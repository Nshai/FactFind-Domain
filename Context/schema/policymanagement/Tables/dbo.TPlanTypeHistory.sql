CREATE TABLE [dbo].[TPlanTypeHistory]
(
[PlanTypeHistoryId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[DateOfChange] [datetime] NOT NULL CONSTRAINT [DF_TPlanTypeHistory_DateOfChange] DEFAULT (getdate()),
[ChangedByUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanTypeHistory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPlanTypeHistory] ADD CONSTRAINT [PK_TPlanTypeHistory] PRIMARY KEY NONCLUSTERED  ([PlanTypeHistoryId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TPlanTypeHistory] ADD CONSTRAINT [FK_TPlanTypeHistory_PolicyBusinessId_TPolicyBusiness] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPlanTypeHistory] ADD CONSTRAINT [FK_TPlanTypeHistory_RefPlanType2ProdSubTypeId_TRefPlanType2ProdSubType] FOREIGN KEY ([RefPlanType2ProdSubTypeId]) REFERENCES [dbo].[TRefPlanType2ProdSubType] ([RefPlanType2ProdSubTypeId])
GO
