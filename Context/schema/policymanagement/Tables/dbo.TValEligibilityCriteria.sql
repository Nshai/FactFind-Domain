CREATE TABLE [dbo].[TValEligibilityCriteria]
(
[ValEligibilityCriteriaId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ValuationProviderId] [int] NULL,
[EligibilityMask] [int] NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TValEligibilityCriteria] ADD CONSTRAINT [PK_TValEligibilityCriteria] PRIMARY KEY CLUSTERED  ([ValEligibilityCriteriaId])
GO
ALTER TABLE [dbo].[TValEligibilityCriteria] ADD CONSTRAINT [FK_TValEligibilityCriteria_ValuationProviderId_TRefProdProvider] FOREIGN KEY ([ValuationProviderId]) REFERENCES [dbo].[TRefProdProvider] ([RefProdProviderId])
GO
