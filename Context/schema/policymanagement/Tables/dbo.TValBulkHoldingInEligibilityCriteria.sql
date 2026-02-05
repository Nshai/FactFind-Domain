CREATE TABLE [dbo].[TValBulkHoldingInEligibilityCriteria]
(
[ValBulkHoldingInEligibilityCriteriaId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ValuationProviderId] [int] NULL,
[InEligibilityMask] [int] NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TValBulkHoldingInEligibilityCriteria] ADD CONSTRAINT [FK_TValBulkHoldingInEligibilityCriteria_ValuationProviderId_TRefProdProvider] FOREIGN KEY ([ValuationProviderId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO
